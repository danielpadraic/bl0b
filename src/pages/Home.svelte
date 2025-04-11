<script>
  import { onMount, onDestroy } from "svelte";
  import { user, showChallengeCreation } from "../stores.js";
  import { supabase } from "../supabase.js";
  import ChallengeCard from "../components/ChallengeCard.svelte";
  import ReelsCarousel from "../components/ReelsCarousel.svelte";
  import StoriesBanner from "../components/StoriesBanner.svelte";
  import NewChallengeButton from "../components/NewChallengeButton.svelte";
  import LoadingSpinner from "../components/LoadingSpinner.svelte";
  import ChallengeCreation from "../components/ChallengeCreation.svelte";

  let challenges = [];
  let activeChallenges = [];
  let upcomingChallenges = [];
  let popularChallenges = [];
  let loading = true;
  let isComponentMounted = false;
  let error = null;
  let searchQuery = "";
  let selectedFilter = "all";
  let refreshing = false;
  let notificationCount = 0;
  let showAuthPrompt = false;

  let startY = 0;
  let pullDistance = 0;
  let pullThreshold = 80;
  let isPulling = false;

  let authPromptRef;
  let triggerElement;

  onMount(async () => {
    console.log("Home.svelte: Mounting component");
    isComponentMounted = true;

    try {
      if ($user) {
        console.log(
          "User authenticated, fetching challenges and notifications"
        );
        await fetchChallenges();
      } else {
        console.log("No user, fetching public challenges");
        await fetchPublicChallenges();
      }
    } catch (err) {
      console.error("Error during initial data fetch:", err);
      error = "Failed to load content. Please try again.";
    } finally {
      loading = false;
    }

    console.log("Home.svelte: Adding touch event listeners");
    document.addEventListener("touchstart", handleTouchStart, {
      passive: true,
    });
    document.addEventListener("touchmove", handleTouchMove, { passive: true });
    document.addEventListener("touchend", handleTouchEnd, { passive: true });
  });

  onDestroy(() => {
    console.log("Home.svelte: Destroying component, removing event listeners");
    isComponentMounted = false;
    document.removeEventListener("touchstart", handleTouchStart);
    document.removeEventListener("touchmove", handleTouchMove);
    document.removeEventListener("touchend", handleTouchEnd);
  });

  function handleTouchStart(e) {
    startY = e.touches[0].clientY;
    const scrollTop =
      document.documentElement.scrollTop || document.body.scrollTop;
    if (scrollTop <= 0) {
      isPulling = true;
    }
  }

  function handleTouchMove(e) {
    if (!isPulling) return;
    const currentY = e.touches[0].clientY;
    pullDistance = Math.max(0, currentY - startY);
  }

  async function handleTouchEnd() {
    if (pullDistance > pullThreshold) {
      await refreshContent();
    }
    isPulling = false;
    pullDistance = 0;
  }

  async function refreshContent() {
    refreshing = true;
    try {
      if ($user) {
        await fetchChallenges();
      } else {
        await fetchPublicChallenges();
      }
    } catch (err) {
      console.error("Error during refresh:", err);
      error = "Failed to refresh content. Please try again.";
    } finally {
      refreshing = false;
    }
  }

  async function fetchChallenges() {
    if (!isComponentMounted) return;

    try {
      const { data: participantData, error: participantError } = await supabase
        .from("challenge_participants")
        .select("challenge_id")
        .eq("user_id", $user.id);

      if (participantError) throw participantError;

      const userChallengeIds =
        participantData?.map((p) => p.challenge_id) || [];

      const { data: challengeData, error: challengeError } =
        await supabase.from("challenges").select(`
              id, 
              title, 
              type, 
              cover_media, 
              participants_max, 
              participants_current,
              prize_pool,
              buy_in_cost,
              start_datetime,
              end_datetime,
              is_private,
              profiles!challenges_creator_id_fkey(username, profile_photo_url)
            `);

      if (challengeError) throw challengeError;

      if (!isComponentMounted) return;

      const processedChallenges = challengeData.map((challenge) => ({
        ...challenge,
        isJoined: userChallengeIds.includes(challenge.id),
        creatorUsername: challenge.profiles?.username || "Unknown",
        creatorPhoto: challenge.profiles?.profile_photo_url || null,
        status: getTimeStatus(challenge.start_datetime, challenge.end_datetime),
      }));

      challenges = processedChallenges;
      activeChallenges = processedChallenges.filter(
        (c) => c.status === "active" && c.isJoined
      );
      upcomingChallenges = processedChallenges.filter(
        (c) => c.status === "upcoming" && c.isJoined
      );
      popularChallenges = processedChallenges
        .filter((c) => !c.isJoined && !c.is_private)
        .sort((a, b) => b.participants_current - a.participants_current)
        .slice(0, 10);
    } catch (err) {
      console.error("Error fetching challenges:", err);
      error = "Failed to load challenges. Please try again.";
      activeChallenges = [];
      upcomingChallenges = [];
      popularChallenges = [];
    }
  }

  async function fetchPublicChallenges() {
    if (!isComponentMounted) return;

    try {
      const { data: challengeData, error: challengeError } = await supabase
        .from("challenges")
        .select(
          `
                id, 
                title, 
                type, 
                cover_media, 
                participants_max, 
                participants_current,
                prize_pool,
                buy_in_cost,
                start_datetime,
                end_datetime,
                is_private,
                profiles!challenges_creator_id_fkey(username, profile_photo_url)
              `
        )
        .eq("is_private", false);

      if (challengeError) throw challengeError;

      if (!isComponentMounted) return;

      const processedChallenges = challengeData.map((challenge) => ({
        ...challenge,
        isJoined: false,
        creatorUsername: challenge.profiles?.username || "Unknown",
        creatorPhoto: challenge.profiles?.profile_photo_url || null,
        status: getTimeStatus(challenge.start_datetime, challenge.end_datetime),
      }));

      challenges = processedChallenges;
      activeChallenges = processedChallenges.filter(
        (c) => c.status === "active"
      );
      upcomingChallenges = processedChallenges.filter(
        (c) => c.status === "upcoming"
      );
      popularChallenges = processedChallenges
        .sort((a, b) => b.participants_current - a.participants_current)
        .slice(0, 10);
    } catch (err) {
      console.error("Error fetching public challenges:", err);
      error = "Failed to load challenges. Please try again.";
      activeChallenges = [];
      upcomingChallenges = [];
      popularChallenges = [];
    }
  }

  function getTimeStatus(startDateStr, endDateStr) {
    const now = new Date();
    const startDate = startDateStr ? new Date(startDateStr) : null;
    const endDate = endDateStr ? new Date(endDateStr) : null;

    if (!startDate || !endDate) return "unknown";

    if (now < startDate) return "upcoming";
    if (now >= startDate && now < endDate) return "active";
    return "completed";
  }

  function filterChallenges() {
    let filtered = challenges;

    if (searchQuery) {
      const query = searchQuery.toLowerCase();
      filtered = filtered.filter(
        (challenge) =>
          challenge.title.toLowerCase().includes(query) ||
          challenge.type.toLowerCase().includes(query)
      );
    }

    if (selectedFilter !== "all") {
      filtered = filtered.filter((challenge) => {
        if (selectedFilter === "joined") return challenge.isJoined;
        if (selectedFilter === "active") return challenge.status === "active";
        if (selectedFilter === "upcoming")
          return challenge.status === "upcoming";
        if (selectedFilter === "completed")
          return challenge.status === "completed";
        if (selectedFilter === "fitness") return challenge.type === "Fitness";
        return challenge.type !== "Fitness";
      });
    }

    return filtered;
  }

  function handleCreateChallenge(event) {
    if (!$user) {
      openAuthPrompt(event);
    } else {
      $showChallengeCreation = true;
    }
  }

  function handleJoinChallenge(challengeId) {
    if (!$user) {
      showAuthPrompt = true;
      return;
    }

    window.navigateTo(`/challenge/${challengeId}`);
  }

  function openAuthPrompt(event) {
    triggerElement = event.target;
    showAuthPrompt = true;
    setTimeout(() => {
      authPromptRef?.querySelector(".primary-btn")?.focus();
    }, 0);
  }

  function closeAuthPrompt() {
    showAuthPrompt = false;
    setTimeout(() => {
      triggerElement?.focus();
    }, 0);
  }

  function handleLogin() {
    closeAuthPrompt();
    window.navigateTo("/login");
  }

  function handleSignup() {
    closeAuthPrompt();
    window.navigateTo("/signup");
  }

  function handleOverlayClick(event) {
    if (event.target === event.currentTarget) {
      closeAuthPrompt();
    }
  }
</script>

<div class="home-container" class:pulling={pullDistance > 0}>
  {#if loading}
    <div class="app-loading">
      <LoadingSpinner />
    </div>
  {:else}
    {#if pullDistance > 0 || refreshing}
      <div
        class="pull-indicator"
        class:ready={pullDistance > pullThreshold}
        class:refreshing
        style="height: {Math.min(pullDistance, 100)}px"
      >
        <div class="spinner">↻</div>
        <span
          >{refreshing
            ? "Refreshing..."
            : pullDistance > pullThreshold
              ? "Release to refresh"
              : "Pull to refresh"}</span
        >
      </div>
    {/if}

    <div class="content">
      <StoriesBanner />
      <ReelsCarousel />
      <section class="challenges-section">
        {#if loading}
          <LoadingSpinner />
        {:else if error}
          <div class="error-message">
            <p>{error}</p>
            <button on:click={refreshContent}>Retry</button>
          </div>
        {:else}
          {#if $user && activeChallenges && activeChallenges.length > 0}
            <div class="section-header">
              <h2>Your Active Challenges</h2>
              <a href="/my-challenges" class="see-all">See All</a>
            </div>
            <div class="challenge-grid">
              {#each activeChallenges.slice(0, 3) as challenge (challenge.id)}
                <ChallengeCard
                  {challenge}
                  on:click={() =>
                    window.navigateTo(`/challenge/${challenge.id}`)}
                />
              {/each}
            </div>
          {/if}

          {#if $user && upcomingChallenges && upcomingChallenges.length > 0}
            <div class="section-header">
              <h2>Your Upcoming Challenges</h2>
              <a href="/my-challenges" class="see-all">See All</a>
            </div>
            <div class="challenge-grid">
              {#each upcomingChallenges.slice(0, 3) as challenge (challenge.id)}
                <ChallengeCard
                  {challenge}
                  on:click={() =>
                    window.navigateTo(`/challenge/${challenge.id}`)}
                />
              {/each}
            </div>
          {/if}

          {#if popularChallenges && popularChallenges.length > 0}
            <div class="section-header">
              <h2>Popular Challenges</h2>
              <a href="/discover" class="see-all">See All</a>
            </div>
            <div class="challenge-grid">
              {#each popularChallenges.slice(0, 6) as challenge (challenge.id)}
                <ChallengeCard
                  {challenge}
                  on:click={() =>
                    window.navigateTo(`/challenge/${challenge.id}`)}
                />
              {/each}
            </div>
          {/if}

          {#if $user}
            <div class="section-header">
              <h2>Friends' Challenges</h2>
              <a href="/discover" class="see-all">See All</a>
            </div>
            <div class="challenge-grid">
              <div class="empty-state">
                <p>Your friends' challenges will appear here</p>
                <button on:click={() => window.navigateTo("/social")}>
                  Find Friends
                </button>
              </div>
            </div>
          {/if}
        {/if}
      </section>
    </div>

    <NewChallengeButton on:click={handleCreateChallenge} />

    {#if showAuthPrompt}
      <div
        class="modal-overlay"
        tabindex="0"
        role="button"
        on:click={handleOverlayClick}
        on:keydown={(e) => {
          if (e.key === "Enter" || e.key === "Space") {
            e.preventDefault();
            closeAuthPrompt();
          }
        }}
      >
        <div
          class="auth-prompt"
          role="dialog"
          aria-labelledby="auth-prompt-title"
          bind:this={authPromptRef}
        >
          <h3 id="auth-prompt-title">Join the Competition!</h3>
          <p>
            Sign in or create an account to join challenges and track your
            progress.
          </p>
          <div class="button-group">
            <button class="primary-btn" on:click={handleLogin}>Log In</button>
            <button class="secondary-btn" on:click={handleSignup}>
              Sign Up
            </button>
          </div>
          <button class="close-btn" on:click={() => closeAuthPrompt()}>
            ✕
          </button>
        </div>
      </div>
    {/if}

    {#if $showChallengeCreation}
      <ChallengeCreation />
    {/if}
  {/if}
</div>

<style>
  .home-container {
    padding-top: 60px;
    padding-bottom: 60px;
    width: 100%;
    background-color: var(--background);
    position: relative;
    min-height: 100vh;
    overflow-x: hidden;
  }

  .content {
    transition: transform 0.3s ease;
  }

  .pulling .content {
    transform: translateY(var(--pull-distance, 0px));
  }

  .pull-indicator {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    background-color: var(--light-gray);
    color: var(--charcoal);
    font-size: 0.9rem;
    overflow: hidden;
    transition: height 0.3s ease;
    z-index: 10;
  }

  .spinner {
    font-size: 1.5rem;
    margin-right: 10px;
    transition: transform 0.3s ease;
  }

  .pull-indicator.ready .spinner {
    transform: rotate(180deg);
  }

  .pull-indicator.refreshing .spinner {
    animation: spin 1s infinite linear;
  }

  @keyframes spin {
    from {
      transform: rotate(0deg);
    }
    to {
      transform: rotate(360deg);
    }
  }

  .challenges-section {
    padding: 0 16px;
  }

  .section-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin: 20px 0 12px;
  }

  .section-header h2 {
    font-size: 1.25rem;
    color: var(--charcoal);
    margin: 0;
    font-weight: 600;
  }

  .see-all {
    color: var(--tomato);
    text-decoration: none;
    font-size: 0.9rem;
    font-weight: 500;
  }

  .challenge-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
    gap: 12px;
    margin-bottom: 24px;
  }

  .empty-state {
    background-color: var(--light-gray);
    border-radius: 12px;
    padding: 16px;
    text-align: center;
    grid-column: 1 / -1;
  }

  .empty-state p {
    color: var(--charcoal);
    margin-bottom: 12px;
  }

  .empty-state button {
    background-color: var(--tomato);
    color: white;
    border: none;
    padding: 8px 16px;
    border-radius: 20px;
    font-size: 0.9rem;
  }

  .error-message {
    background-color: #fff0f0;
    border: 1px solid #ffcaca;
    padding: 16px;
    border-radius: 8px;
    margin: 20px 0;
    text-align: center;
  }

  .error-message p {
    color: var(--tomato);
    margin-bottom: 12px;
  }

  .modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(0, 0, 0, 0.6);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 1000;
  }

  .auth-prompt {
    background-color: white;
    border-radius: 12px;
    padding: 24px;
    width: 90%;
    max-width: 400px;
    position: relative;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  }

  .auth-prompt h3 {
    font-size: 1.3rem;
    color: var(--charcoal);
    margin: 0 0 12px;
    text-align: center;
  }

  .auth-prompt p {
    color: var(--gray);
    margin-bottom: 20px;
    text-align: center;
  }

  .button-group {
    display: flex;
    gap: 12px;
  }

  .primary-btn,
  .secondary-btn {
    flex: 1;
    padding: 12px;
    border-radius: 8px;
    border: none;
    font-weight: 500;
    cursor: pointer;
  }

  .primary-btn {
    background-color: var(--tomato);
    color: white;
  }

  .secondary-btn {
    background-color: var(--light-gray);
    color: var(--charcoal);
  }

  .close-btn {
    position: absolute;
    top: 10px;
    right: 10px;
    background: none;
    border: none;
    color: var(--gray);
    font-size: 1.2rem;
    cursor: pointer;
    padding: 5px;
  }

  .app-loading {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: var(--background);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 9999;
  }
</style>
