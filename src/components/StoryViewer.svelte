<script>
  import { onMount, onDestroy, tick } from "svelte";
  import { user } from "../stores.js";
  import { supabase } from "../supabase.js";
  import { navigate } from "svelte-routing";

  export let storyId = null;
  export let username = null;

  let stories = [];
  let currentStoryIndex = 0;
  let currentSegmentIndex = 0;
  let loading = true;
  let error = null;
  let progress = [];
  let timer = null;
  let segmentDuration = 5000; // 5 seconds per segment
  let isPaused = false;
  let interactionVisible = true;

  // For interactive elements
  let userResponse = null;
  let selectedPollOption = null;
  let sliderValue = 0;
  let textResponse = "";

  onMount(async () => {
    console.log(
      `StoryViewer mounted for ${username || "all stories"}, storyId: ${storyId}`
    );
    await loadStories();
    startProgressTimer();

    // Listen for key presses
    window.addEventListener("keydown", handleKeydown);

    return () => {
      clearTimeout(timer);
      window.removeEventListener("keydown", handleKeydown);
    };
  });

  onDestroy(() => {
    clearTimeout(timer);
  });

  async function loadStories() {
    try {
      let query = supabase
        .from("stories")
        .select(
          `
    id, 
    user_id, 
    media_url, 
    text_overlay, 
    text_position, 
    font_color, 
    font_size,
    interactive_element, 
    created_at, 
    expires_at,
    profiles!stories_user_id_fkey(username, profile_photo_url)
  `
        )
        .gt("expires_at", new Date().toISOString()) // Changed from .lt to .gt
        .order("created_at", { ascending: false });

      // If username is provided, filter by that user
      if (username) {
        const { data: userData } = await supabase
          .from("profiles")
          .select("id")
          .eq("username", username)
          .single();

        if (userData) {
          query = query.eq("user_id", userData.id);
        } else {
          throw new Error("User not found");
        }
      }

      // If storyId is provided, load just that story
      if (storyId) {
        query = query.eq("id", storyId);
      }

      const { data, error: storiesError } = await query;

      if (storiesError) throw storiesError;

      if (!data || data.length === 0) {
        throw new Error("No stories found");
      }

      // Group stories by user for the carousel experience
      const storiesByUser = data.reduce((acc, story) => {
        const userId = story.user_id;
        if (!acc[userId]) {
          acc[userId] = [];
        }

        acc[userId].push({
          ...story,
          username: story.profiles?.username || "unknown",
          userPhoto: story.profiles?.profile_photo_url || null,
        });

        return acc;
      }, {});

      // Convert to array format for our carousel
      stories = Object.values(storiesByUser);

      // If a specific storyId was provided, find its position
      if (storyId) {
        for (let i = 0; i < stories.length; i++) {
          const storyGroup = stories[i];
          const storyIndex = storyGroup.findIndex((s) => s.id === storyId);
          if (storyIndex !== -1) {
            currentStoryIndex = i;
            currentSegmentIndex = storyIndex;
            break;
          }
        }
      }

      // Initialize progress array
      initializeProgress();

      await markStoryAsViewed();

      loading = false;
    } catch (err) {
      console.error("Error loading stories:", err);
      error = err.message;
      loading = false;
    }
  }

  function initializeProgress() {
    progress = stories.map((userStories) =>
      userStories.map(() => ({ elapsed: 0, total: segmentDuration }))
    );
  }

  function startProgressTimer() {
    if (stories.length === 0) return;

    clearTimeout(timer);

    if (isPaused) return;

    timer = setTimeout(async () => {
      // Update progress for current segment
      if (
        progress[currentStoryIndex] &&
        progress[currentStoryIndex][currentSegmentIndex]
      ) {
        progress[currentStoryIndex][currentSegmentIndex].elapsed += 100;
        progress = [...progress];
      }

      // Check if segment is complete
      if (
        progress[currentStoryIndex]?.[currentSegmentIndex]?.elapsed >=
        segmentDuration
      ) {
        await nextSegment();
      } else {
        startProgressTimer();
      }
    }, 100);
  }

  async function markStoryAsViewed() {
    if (!$user || stories.length === 0) return;

    const currentUserStories = stories[currentStoryIndex];
    if (!currentUserStories || !currentUserStories[currentSegmentIndex]) return;

    const storyId = currentUserStories[currentSegmentIndex].id;

    try {
      await supabase.from("story_views").upsert([
        {
          user_id: $user.id,
          story_id: storyId,
          viewed_at: new Date().toISOString(),
        },
      ]);
    } catch (err) {
      console.error("Error marking story as viewed:", err);
    }
  }

  async function nextSegment() {
    if (stories.length === 0) return;

    const currentUserStories = stories[currentStoryIndex];

    // Move to next segment in current user's stories
    if (currentSegmentIndex < currentUserStories.length - 1) {
      currentSegmentIndex++;
    }
    // Move to next user's stories
    else if (currentStoryIndex < stories.length - 1) {
      currentStoryIndex++;
      currentSegmentIndex = 0;
    }
    // End of all stories
    else {
      close();
      return;
    }

    // Reset response for new interactive element
    resetInteractionState();

    // Mark as viewed
    await markStoryAsViewed();

    // Restart timer
    startProgressTimer();
  }

  async function previousSegment() {
    if (stories.length === 0) return;

    // Move to previous segment in current user's stories
    if (currentSegmentIndex > 0) {
      currentSegmentIndex--;
    }
    // Move to previous user's last story
    else if (currentStoryIndex > 0) {
      currentStoryIndex--;
      const previousUserStories = stories[currentStoryIndex];
      currentSegmentIndex = previousUserStories.length - 1;
    }

    // Reset response for new interactive element
    resetInteractionState();

    // Reset progress for this segment
    if (
      progress[currentStoryIndex] &&
      progress[currentStoryIndex][currentSegmentIndex]
    ) {
      progress[currentStoryIndex][currentSegmentIndex].elapsed = 0;
      progress = [...progress];
    }

    // Restart timer
    startProgressTimer();
  }

  function resetInteractionState() {
    userResponse = null;
    selectedPollOption = null;
    sliderValue = 0;
    textResponse = "";
    interactionVisible = true;
  }

  function togglePause() {
    isPaused = !isPaused;
    if (isPaused) {
      clearTimeout(timer);
    } else {
      startProgressTimer();
    }
  }

  async function submitPollResponse(optionIndex) {
    if (!$user) return;

    const currentStory = stories[currentStoryIndex]?.[currentSegmentIndex];
    if (!currentStory || !currentStory.interactive_element) return;

    selectedPollOption = optionIndex;

    try {
      // Update the poll results in the database
      const pollOptions = currentStory.interactive_element.options;

      // Make a copy of the options and add the current user to voters
      const updatedOptions = [...pollOptions];
      if (!updatedOptions[optionIndex].votes) {
        updatedOptions[optionIndex].votes = [];
      }

      // Check if user has already voted for any option
      let previousVote = null;
      for (let i = 0; i < updatedOptions.length; i++) {
        if (
          updatedOptions[i].votes &&
          updatedOptions[i].votes.includes($user.id)
        ) {
          previousVote = i;
          break;
        }
      }

      // Remove previous vote if exists
      if (previousVote !== null && previousVote !== optionIndex) {
        updatedOptions[previousVote].votes = updatedOptions[
          previousVote
        ].votes.filter((id) => id !== $user.id);
      }

      // Add new vote
      if (!updatedOptions[optionIndex].votes.includes($user.id)) {
        updatedOptions[optionIndex].votes.push($user.id);
      }

      // Update the story with new interactive element data
      await supabase
        .from("stories")
        .update({
          interactive_element: {
            ...currentStory.interactive_element,
            options: updatedOptions,
          },
        })
        .eq("id", currentStory.id);

      // Update local state to show results
      stories[currentStoryIndex][
        currentSegmentIndex
      ].interactive_element.options = updatedOptions;
      stories = [...stories];
    } catch (err) {
      console.error("Error submitting poll response:", err);
    }
  }

  async function submitQuestionResponse() {
    if (!$user || !textResponse.trim()) return;

    const currentStory = stories[currentStoryIndex]?.[currentSegmentIndex];
    if (!currentStory || !currentStory.interactive_element) return;

    try {
      // Update the question responses in the database
      const responses = currentStory.interactive_element.responses || [];

      // Add the new response
      const newResponse = {
        user_id: $user.id,
        response: textResponse,
        timestamp: new Date().toISOString(),
      };

      // Update the story with new interactive element data
      await supabase
        .from("stories")
        .update({
          interactive_element: {
            ...currentStory.interactive_element,
            responses: [...responses, newResponse],
          },
        })
        .eq("id", currentStory.id);

      // Update local state
      stories[currentStoryIndex][
        currentSegmentIndex
      ].interactive_element.responses = [...responses, newResponse];
      stories = [...stories];

      // Show confirmation
      userResponse = textResponse;
      textResponse = "";
    } catch (err) {
      console.error("Error submitting question response:", err);
    }
  }

  async function submitSliderResponse() {
    if (!$user) return;

    const currentStory = stories[currentStoryIndex]?.[currentSegmentIndex];
    if (!currentStory || !currentStory.interactive_element) return;

    try {
      // Update the slider responses in the database
      const responses = currentStory.interactive_element.responses || [];

      // Check if user has already responded
      const existingResponseIndex = responses.findIndex(
        (r) => r.user_id === $user.id
      );

      let updatedResponses;
      if (existingResponseIndex !== -1) {
        // Update existing response
        updatedResponses = [...responses];
        updatedResponses[existingResponseIndex] = {
          ...updatedResponses[existingResponseIndex],
          value: sliderValue,
          timestamp: new Date().toISOString(),
        };
      } else {
        // Add new response
        updatedResponses = [
          ...responses,
          {
            user_id: $user.id,
            value: sliderValue,
            timestamp: new Date().toISOString(),
          },
        ];
      }

      // Update the story with new interactive element data
      await supabase
        .from("stories")
        .update({
          interactive_element: {
            ...currentStory.interactive_element,
            responses: updatedResponses,
          },
        })
        .eq("id", currentStory.id);

      // Update local state
      stories[currentStoryIndex][
        currentSegmentIndex
      ].interactive_element.responses = updatedResponses;
      stories = [...stories];

      // Show confirmation
      userResponse = sliderValue;
    } catch (err) {
      console.error("Error submitting slider response:", err);
    }
  }

  function calculatePollPercentage(option) {
    if (!option.votes || option.votes.length === 0) return 0;

    const currentStory = stories[currentStoryIndex]?.[currentSegmentIndex];
    if (!currentStory || !currentStory.interactive_element) return 0;

    const options = currentStory.interactive_element.options;
    const totalVotes = options.reduce(
      (total, opt) => total + (opt.votes ? opt.votes.length : 0),
      0
    );

    if (totalVotes === 0) return 0;

    return Math.round((option.votes.length / totalVotes) * 100);
  }

  function handleKeydown(event) {
    if (event.key === "ArrowLeft") {
      previousSegment();
    } else if (event.key === "ArrowRight") {
      nextSegment();
    } else if (event.key === "Escape") {
      close();
    } else if (event.key === " ") {
      // Space bar
      togglePause();
    }
  }

  function close() {
    navigate("/");
  }

  function getTotalResponses(interactive) {
    if (!interactive || !interactive.responses) return 0;
    return interactive.responses.length;
  }

  function getAverageSliderValue(interactive) {
    if (
      !interactive ||
      !interactive.responses ||
      interactive.responses.length === 0
    )
      return 0;

    const sum = interactive.responses.reduce(
      (total, response) => total + response.value,
      0
    );
    return Math.round(sum / interactive.responses.length);
  }

  function hasUserVoted() {
    if (!$user) return false;

    const currentStory = stories[currentStoryIndex]?.[currentSegmentIndex];
    if (!currentStory || !currentStory.interactive_element) return false;

    if (currentStory.interactive_element.type === "poll") {
      return currentStory.interactive_element.options.some(
        (option) => option.votes && option.votes.includes($user.id)
      );
    }

    if (
      currentStory.interactive_element.type === "question" ||
      currentStory.interactive_element.type === "slider"
    ) {
      return currentStory.interactive_element.responses?.some(
        (response) => response.user_id === $user.id
      );
    }

    return false;
  }

  function getUserVotedOption() {
    if (!$user) return -1;

    const currentStory = stories[currentStoryIndex]?.[currentSegmentIndex];
    if (!currentStory || !currentStory.interactive_element) return -1;

    if (currentStory.interactive_element.type !== "poll") return -1;

    for (let i = 0; i < currentStory.interactive_element.options.length; i++) {
      const option = currentStory.interactive_element.options[i];
      if (option.votes && option.votes.includes($user.id)) {
        return i;
      }
    }

    return -1;
  }

  function getUserResponse() {
    if (!$user) return null;

    const currentStory = stories[currentStoryIndex]?.[currentSegmentIndex];
    if (!currentStory || !currentStory.interactive_element) return null;

    if (
      currentStory.interactive_element.type !== "question" &&
      currentStory.interactive_element.type !== "slider"
    )
      return null;

    const userResponse = currentStory.interactive_element.responses?.find(
      (response) => response.user_id === $user.id
    );

    return userResponse;
  }
</script>

{#if loading}
  <div class="stories-loading">
    <div class="loading-spinner"></div>
    <span>Loading stories...</span>
  </div>
{:else if error}
  <div class="stories-error">
    <p>{error}</p>
    <button on:click={close}>Back to Home</button>
  </div>
{:else if stories.length === 0}
  <div class="stories-empty">
    <p>No stories available</p>
    <button on:click={close}>Back to Home</button>
  </div>
{:else}
  <div
    class="story-viewer"
    on:click={nextSegment}
    on:keydown={handleKeydown}
    role="region"
    aria-label="Story viewer"
    tabindex="0"
  >
    <!-- Story header -->
    <div
      class="story-header"
      on:click|stopPropagation
      role="navigation"
      aria-label="Story navigation"
    >
      <div class="progress-bar-container">
        {#each stories[currentStoryIndex] as _, i}
          <div class="progress-bar">
            <div
              class="progress-fill"
              style="width: {(progress[currentStoryIndex][i]?.elapsed /
                progress[currentStoryIndex][i]?.total) *
                100}%"
            ></div>
          </div>
        {/each}
      </div>

      <div class="user-info">
        {#if stories[currentStoryIndex][0].userPhoto}
          <img
            src={stories[currentStoryIndex][0].userPhoto}
            alt={stories[currentStoryIndex][0].username}
            class="user-avatar"
          />
        {:else}
          <div class="avatar-placeholder">
            {stories[currentStoryIndex][0].username.charAt(0).toUpperCase()}
          </div>
        {/if}
        <span class="username">@{stories[currentStoryIndex][0].username}</span>
        <span class="timestamp">
          {new Date(
            stories[currentStoryIndex][currentSegmentIndex].created_at
          ).toLocaleTimeString(undefined, {
            hour: "2-digit",
            minute: "2-digit",
          })}
        </span>
      </div>

      <button class="close-button" on:click={close} aria-label="Close story"
        >×</button
      >
    </div>

    <!-- Story content -->
    {#if stories[currentStoryIndex][currentSegmentIndex]}
      {@const currentStory = stories[currentStoryIndex][currentSegmentIndex]}
      <div class="story-content">
        {#if currentStory.media_url}
          {#if currentStory.media_url.endsWith(".mp4") || currentStory.media_url.endsWith(".webm")}
            <button
              class="media-button"
              on:click|stopPropagation={togglePause}
              aria-label={isPaused ? "Play video" : "Pause video"}
            >
              <video
                src={currentStory.media_url}
                autoplay
                loop
                muted
                playsinline
              >
                <track kind="captions" />
              </video>
            </button>
          {:else}
            <button
              class="media-button"
              on:click|stopPropagation={togglePause}
              aria-label={isPaused ? "Continue story" : "Pause story"}
            >
              <img src={currentStory.media_url} alt="Story content" />
            </button>
          {/if}
        {/if}

        {#if currentStory.text_overlay}
          <div
            class="text-overlay {currentStory.text_position || 'center'}"
            style="color: {currentStory.font_color ||
              '#ffffff'}; font-size: {currentStory.font_size === 'small'
              ? '16px'
              : currentStory.font_size === 'large'
                ? '32px'
                : '24px'}"
          >
            {currentStory.text_overlay}
          </div>
        {/if}

        <!-- Interactive elements -->
        {#if currentStory.interactive_element && interactionVisible}
          <div
            class="interactive-element"
            on:click|stopPropagation
            role="region"
            aria-label="Interactive story element"
          >
            {#if currentStory.interactive_element.type === "poll"}
              <div class="poll-container">
                <h3>{currentStory.interactive_element.title || "Poll"}</h3>

                {#if hasUserVoted() || selectedPollOption !== null}
                  <!-- Show poll results -->
                  <div class="poll-results">
                    {#each currentStory.interactive_element.options as option, i}
                      {@const percentage = calculatePollPercentage(option)}
                      {@const isUserVote =
                        getUserVotedOption() === i || selectedPollOption === i}

                      <div
                        class="poll-result-item"
                        class:user-voted={isUserVote}
                      >
                        <div class="poll-bar-container">
                          <div
                            class="poll-bar"
                            style="width: {percentage}%"
                          ></div>
                          <span class="poll-text">{option.text}</span>
                          <span class="poll-percentage">{percentage}%</span>
                        </div>
                      </div>
                    {/each}

                    <p class="total-votes">
                      {currentStory.interactive_element.options.reduce(
                        (total, opt) =>
                          total + (opt.votes ? opt.votes.length : 0),
                        0
                      )} votes
                    </p>
                  </div>
                {:else}
                  <!-- Show voting options -->
                  <div class="poll-options">
                    {#each currentStory.interactive_element.options as option, i}
                      <button
                        class="poll-option-btn"
                        on:click={() => submitPollResponse(i)}
                        aria-label={`Vote for ${option.text}`}
                      >
                        {option.text}
                      </button>
                    {/each}
                  </div>
                {/if}
              </div>
            {:else if currentStory.interactive_element.type === "question"}
              <div class="question-container">
                <h3>{currentStory.interactive_element.question}</h3>

                {#if userResponse || getUserResponse()}
                  <!-- Show thank you message -->
                  <div class="response-confirmation">
                    <p class="thank-you">Thanks for your response!</p>
                    <p class="response-total">
                      {getTotalResponses(currentStory.interactive_element)}
                      {getTotalResponses(currentStory.interactive_element) === 1
                        ? "person has"
                        : "people have"} responded
                    </p>
                  </div>
                {:else}
                  <!-- Show question input -->
                  <div class="question-input">
                    <input
                      type="text"
                      bind:value={textResponse}
                      placeholder="Type your answer..."
                      on:keydown={(e) =>
                        e.key === "Enter" && submitQuestionResponse()}
                      aria-label="Your answer"
                    />
                    <button
                      on:click={submitQuestionResponse}
                      aria-label="Submit answer">Send</button
                    >
                  </div>
                {/if}
              </div>
            {:else if currentStory.interactive_element.type === "slider"}
              <div class="slider-container">
                <h3>{currentStory.interactive_element.label}</h3>

                {#if userResponse !== null || getUserResponse()}
                  <!-- Show results -->
                  <div class="slider-results">
                    <p class="slider-average">
                      Average: {getAverageSliderValue(
                        currentStory.interactive_element
                      )}
                    </p>
                    <p class="response-total">
                      {getTotalResponses(currentStory.interactive_element)}
                      {getTotalResponses(currentStory.interactive_element) === 1
                        ? "person has"
                        : "people have"} responded
                    </p>
                  </div>
                {:else}
                  <!-- Show slider input -->
                  <div class="slider-input">
                    <input
                      type="range"
                      bind:value={sliderValue}
                      min={currentStory.interactive_element.min || 0}
                      max={currentStory.interactive_element.max || 100}
                      aria-label={`Rate from ${currentStory.interactive_element.min || 0} to ${currentStory.interactive_element.max || 100}`}
                    />
                    <div class="slider-value">{sliderValue}</div>
                    <button
                      on:click={submitSliderResponse}
                      aria-label="Submit rating">Submit</button
                    >
                  </div>
                {/if}
              </div>
            {/if}
          </div>
        {/if}
      </div>

      <!-- Navigation controls -->
      <div
        class="navigation-controls"
        on:click|stopPropagation
        role="navigation"
        aria-label="Story navigation"
      >
        <button
          class="nav-button prev-button"
          on:click={(e) => {
            e.stopPropagation();
            previousSegment();
          }}
          aria-label="Previous story"
        ></button>

        <button
          class="nav-button next-button"
          on:click={(e) => {
            e.stopPropagation();
            nextSegment();
          }}
          aria-label="Next story"
        ></button>
      </div>
    {/if}
  </div>
{/if}

<style>
  .stories-loading,
  .stories-error,
  .stories-empty {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: #000;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    color: #fff;
    z-index: 1000;
  }

  .loading-spinner {
    width: 40px;
    height: 40px;
    border: 4px solid rgba(255, 255, 255, 0.3);
    border-radius: 50%;
    border-top-color: #fff;
    animation: spin 1s linear infinite;
    margin-bottom: 16px;
  }

  @keyframes spin {
    0% {
      transform: rotate(0deg);
    }
    100% {
      transform: rotate(360deg);
    }
  }

  .story-viewer {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: #000;
    z-index: 1000;
    display: flex;
    flex-direction: column;
  }

  .stor/* CSS Styles for StoryViewer.svelte */
  .story-header {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    padding: 16px 16px 8px;
    z-index: 10;
    display: flex;
    flex-direction: column;
  }

  .progress-bar-container {
    display: flex;
    gap: 4px;
    margin-bottom: 8px;
  }

  .progress-bar {
    height: 3px;
    background-color: rgba(255, 255, 255, 0.3);
    border-radius: 3px;
    overflow: hidden;
    flex: 1;
  }

  .progress-fill {
    height: 100%;
    background-color: #fff;
    border-radius: 3px;
    transition: width 0.1s linear;
  }

  .user-info {
    display: flex;
    align-items: center;
    gap: 8px;
  }

  .user-avatar,
  .avatar-placeholder {
    width: 32px;
    height: 32px;
    border-radius: 50%;
  }

  .avatar-placeholder {
    background-color: var(--carolina-blue);
    color: #fff;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: bold;
  }

  .username {
    color: #fff;
    font-weight: 600;
    font-size: 14px;
  }

  .timestamp {
    color: rgba(255, 255, 255, 0.7);
    font-size: 12px;
    margin-left: auto;
  }

  .close-button {
    position: absolute;
    top: 16px;
    right: 16px;
    background: none;
    border: none;
    color: #fff;
    font-size: 24px;
    cursor: pointer;
    z-index: 15;
  }

  .story-content {
    flex: 1;
    position: relative;
    display: flex;
    align-items: center;
    justify-content: center;
    overflow: hidden;
  }

  .media-button {
    background: none;
    border: none;
    padding: 0;
    width: 100%;
    height: 100%;
    cursor: pointer;
  }

  .media-button img,
  .media-button video {
    width: 100%;
    height: 100%;
    object-fit: contain;
  }

  .text-overlay {
    position: absolute;
    left: 16px;
    right: 16px;
    text-align: center;
    color: #fff;
    font-weight: bold;
    text-shadow: 0 1px 3px rgba(0, 0, 0, 0.5);
  }

  .text-overlay.top {
    top: 80px;
  }

  .text-overlay.center {
    top: 50%;
    transform: translateY(-50%);
  }

  .text-overlay.bottom {
    bottom: 120px;
  }

  .navigation-controls {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    pointer-events: none;
  }

  .nav-button {
    position: absolute;
    top: 0;
    bottom: 0;
    width: 50px;
    background: none;
    border: none;
    cursor: pointer;
    pointer-events: auto;
  }

  .prev-button {
    left: 0;
  }

  .next-button {
    right: 0;
  }

  .interactive-element {
    position: absolute;
    bottom: 20px;
    left: 16px;
    right: 16px;
    background-color: rgba(0, 0, 0, 0.7);
    border-radius: 12px;
    padding: 16px;
    color: #fff;
  }

  .interactive-element h3 {
    margin-top: 0;
    margin-bottom: 12px;
    font-size: 16px;
    text-align: center;
  }

  /* Poll Styles */
  .poll-options {
    display: flex;
    flex-direction: column;
    gap: 8px;
  }

  .poll-option-btn {
    background-color: rgba(255, 255, 255, 0.2);
    border: none;
    border-radius: 8px;
    padding: 12px;
    color: #fff;
    font-size: 14px;
    cursor: pointer;
    text-align: center;
    transition: background-color 0.2s;
  }

  .poll-option-btn:hover {
    background-color: rgba(255, 255, 255, 0.3);
  }

  .poll-results {
    display: flex;
    flex-direction: column;
    gap: 10px;
  }

  .poll-result-item {
    position: relative;
  }

  .poll-bar-container {
    height: 36px;
    background-color: rgba(255, 255, 255, 0.1);
    border-radius: 8px;
    overflow: hidden;
    position: relative;
    display: flex;
    align-items: center;
  }

  .poll-bar {
    position: absolute;
    top: 0;
    left: 0;
    height: 100%;
    background-color: rgba(255, 255, 255, 0.2);
    border-radius: 8px;
    transition: width 0.5s ease;
  }

  .user-voted .poll-bar {
    background-color: var(--tomato);
  }

  .poll-text {
    position: relative;
    z-index: 2;
    padding: 0 12px;
    font-size: 14px;
    flex: 1;
  }

  .poll-percentage {
    position: relative;
    z-index: 2;
    padding-right: 12px;
    font-weight: bold;
    font-size: 14px;
  }

  .total-votes {
    text-align: center;
    font-size: 12px;
    color: rgba(255, 255, 255, 0.7);
    margin-top: 8px;
  }

  /* Question Styles */
  .question-input {
    display: flex;
    gap: 8px;
  }

  .question-input input {
    flex: 1;
    background-color: rgba(255, 255, 255, 0.2);
    border: none;
    border-radius: 8px;
    padding: 12px;
    color: #fff;
    font-size: 14px;
  }

  .question-input input::placeholder {
    color: rgba(255, 255, 255, 0.5);
  }

  .question-input button {
    background-color: var(--tomato);
    border: none;
    border-radius: 8px;
    padding: 0 16px;
    color: #fff;
    font-size: 14px;
    cursor: pointer;
  }

  .response-confirmation {
    text-align: center;
  }

  .thank-you {
    font-size: 16px;
    margin-bottom: 8px;
  }

  .response-total {
    font-size: 12px;
    color: rgba(255, 255, 255, 0.7);
  }

  /* Slider Styles */
  .slider-input {
    display: flex;
    flex-direction: column;
    gap: 12px;
    align-items: center;
  }

  .slider-input input[type="range"] {
    width: 100%;
    height: 20px;
    -webkit-appearance: none;
    appearance: none;
    background: rgba(255, 255, 255, 0.2);
    border-radius: 10px;
    overflow: hidden;
  }

  .slider-input input[type="range"]::-webkit-slider-thumb {
    -webkit-appearance: none;
    width: 20px;
    height: 20px;
    border-radius: 50%;
    background: var(--tomato);
    cursor: pointer;
    border: 2px solid #fff;
    box-shadow: 0 0 5px rgba(0, 0, 0, 0.3);
  }

  .slider-value {
    font-size: 20px;
    font-weight: bold;
    margin: 4px 0;
  }

  .slider-input button {
    background-color: var(--tomato);
    border: none;
    border-radius: 8px;
    padding: 10px 20px;
    color: #fff;
    font-size: 14px;
    cursor: pointer;
  }

  .slider-results {
    text-align: center;
  }

  .slider-average {
    font-size: 16px;
    margin-bottom: 8px;
  }

  button {
    cursor: pointer;
  }

  @media (min-width: 768px) {
    .story-content img,
    .story-content video {
      max-width: 400px;
      max-height: 100%;
      margin: 0 auto;
    }

    .interactive-element {
      max-width: 400px;
      margin: 0 auto;
      left: 0;
      right: 0;
    }
  }
</style>
