<script>
  import { onMount, onDestroy } from "svelte";
  import { supabase } from "../supabase.js";
  import { user, showChallengeCreation } from "../stores.js";
  import { navigate } from "svelte-routing";
  import ChallengeCreation from "../components/ChallengeCreation.svelte";
  import TaskCreation from "../components/TaskCreation.svelte";
  import TaskCompletionForm from "../components/TaskCompletionForm.svelte";
  import SocialFeed from "../components/SocialFeed.svelte";
  import LoadingSpinner from "../components/LoadingSpinner.svelte";
  import BottomNav from "../components/BottomNav.svelte";

  export let challengeId;

  let challenge = null;
  let contestants = [];
  let tasks = [];
  let loading = true;
  let error = null;
  let timeLeft = "";
  let timer = null;
  let showTaskCreation = false;
  let editingTaskId = null;
  let showForm = false;
  let selectedTaskId = null;
  let notificationCount = 0;
  let tabSelection = "details"; // "details", "tasks", "leaderboard", "social"

  onMount(async () => {
    console.log("ChallengeDetails mounted with challengeId:", challengeId);
    await fetchChallengeDetails();
    if (challenge) {
      await fetchContestants();
      await fetchTasks();
      startCountdown();
      if ($user) {
        await fetchNotificationCount();
      }
    }
    loading = false;
  });

  onDestroy(() => {
    if (timer) clearInterval(timer);
  });

  async function fetchChallengeDetails() {
    try {
      const { data, error: fetchError } = await supabase
        .from("challenges")
        .select(
          "*, profiles!challenges_creator_id_fkey(username, profile_photo_url)"
        )
        .eq("id", challengeId)
        .single();
      if (fetchError) throw fetchError;
      challenge = data;
    } catch (err) {
      error = err.message;
    }
  }

  async function fetchContestants() {
    try {
      const { data, error: fetchError } = await supabase
        .from("challenge_participants")
        .select("user_id, score")
        .eq("challenge_id", challengeId);
      if (fetchError) throw fetchError;

      if (data.length > 0) {
        const userIds = data.map((participant) => participant.user_id);
        const { data: profilesData, error: profilesError } = await supabase
          .from("profiles")
          .select("id, username, profile_photo_url")
          .in("id", userIds);
        if (profilesError) throw profilesError;

        contestants = data.map((participant) => {
          const profile = profilesData.find(
            (p) => p.id === participant.user_id
          );
          return {
            user_id: participant.user_id,
            username: profile ? profile.username : "Unknown",
            profile_photo_url: profile ? profile.profile_photo_url : null,
            score: participant.score || 0,
          };
        });

        const now = new Date();
        const start = challenge.start_datetime
          ? new Date(challenge.start_datetime)
          : null;
        if (start && now >= start) {
          contestants.sort((a, b) => b.score - a.score);
        } else {
          contestants.sort((a, b) => a.username.localeCompare(b.username));
        }
      }
    } catch (err) {
      error = err.message;
    }
  }

  async function fetchTasks() {
    try {
      const { data, error: fetchError } = await supabase
        .from("tasks")
        .select("*")
        .eq("challenge_id", challengeId)
        .order("created_at", { ascending: true });
      if (fetchError) throw fetchError;
      tasks = data;
    } catch (err) {
      error = err.message;
    }
  }

  async function fetchNotificationCount() {
    if (!$user) return;

    try {
      const { count, error } = await supabase
        .from("notifications")
        .select("id", { count: "exact" })
        .eq("user_id", $user.id)
        .eq("read", false);

      if (!error) {
        notificationCount = count || 0;
      }
    } catch (err) {
      console.error("Error fetching notifications:", err);
    }
  }

  function startCountdown() {
    if (!challenge || !challenge.start_datetime || !challenge.end_datetime)
      return;
    const end = new Date(challenge.end_datetime);
    const start = new Date(challenge.start_datetime);
    const now = new Date();

    if (now < start) return;
    if (now >= end) {
      timeLeft = "Challenge Ended";
      return;
    }

    timer = setInterval(() => {
      const now = new Date();
      const distance = end - now;

      if (distance <= 0) {
        timeLeft = "Challenge Ended";
        clearInterval(timer);
      } else {
        const days = Math.floor(distance / (1000 * 60 * 60 * 24));
        const hours = Math.floor(
          (distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)
        );
        const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
        timeLeft = `${days}d ${hours}h ${minutes}m left`;
      }
    }, 1000);
  }

  function toggleEdit() {
    $showChallengeCreation = true;
  }

  function joinChallenge() {
    if (!$user) {
      navigate("/login");
      return;
    }
    supabase
      .from("challenge_participants")
      .insert([{ challenge_id: challengeId, user_id: $user.id }])
      .then(() => fetchContestants());
  }

  function toggleTaskCreation() {
    showTaskCreation = !showTaskCreation;
    editingTaskId = null;
  }

  async function handleTaskCreated() {
    await fetchTasks();
  }

  async function cancelChallenge() {
    if (
      confirm(
        "Are you sure you want to cancel this challenge? This will delete all associated data."
      )
    ) {
      try {
        const { error: deleteError } = await supabase
          .from("challenges")
          .delete()
          .eq("id", challengeId);
        if (deleteError) throw deleteError;
        navigate("/");
      } catch (err) {
        error = err.message;
      }
    }
  }

  async function editTask(taskId) {
    editingTaskId = taskId;
    showTaskCreation = true;
  }

  async function removeTask(taskId) {
    if (confirm("Are you sure you want to remove this task?")) {
      try {
        const { error: deleteError } = await supabase
          .from("tasks")
          .delete()
          .eq("id", taskId);
        if (deleteError) throw deleteError;
        await fetchTasks();
      } catch (err) {
        error = err.message;
      }
    }
  }

  function handleCompleteTask(taskId) {
    if (!$user) {
      navigate("/login");
      return;
    }
    selectedTaskId = taskId;
    showForm = true;
  }

  function closeForm() {
    showForm = false;
    selectedTaskId = null;
    fetchTasks();
  }

  function getScoreLabel() {
    if (!challenge?.scoring_type) return "Score";
    switch (challenge.scoring_type) {
      case "Time (High)":
      case "Time (Low)":
        return "Time";
      case "Points":
        return "Points";
      case "Distance":
        return "Distance";
      default:
        return "Score";
    }
  }

  function goToCreatorProfile() {
    if (challenge && challenge.profiles && challenge.profiles.username) {
      navigate(`/profile/${challenge.profiles.username}`);
    }
  }

  function formatDate(dateString) {
    if (!dateString) return "N/A";
    const date = new Date(dateString);
    return date.toLocaleDateString(undefined, {
      month: "short",
      day: "numeric",
      year: "numeric",
      hour: "2-digit",
      minute: "2-digit",
    });
  }
</script>

<div class="challenge-details-page">
  {#if loading}
    <div class="loading-container">
      <LoadingSpinner />
    </div>
  {:else if error}
    <div class="error-container">
      <p class="error-message">Error: {error}</p>
      <button class="retry-button" on:click={() => navigate("/")}
        >Go back</button
      >
    </div>
  {:else if challenge}
    <div class="challenge-header">
      <div class="challenge-cover">
        {#if challenge.cover_media}
          {#if challenge.cover_media.match(/\.(jpg|jpeg|png|gif)$/i)}
            <img
              src={challenge.cover_media}
              alt={challenge.title}
              class="cover-image"
            />
          {:else if challenge.cover_media.match(/\.(mp4|webm)$/i)}
            <video controls src={challenge.cover_media} class="cover-video">
              <track kind="captions" label="No captions available" />
            </video>
          {/if}
        {:else}
          <div class="cover-placeholder">
            <span>{challenge.title[0]}</span>
          </div>
        {/if}

        <div class="challenge-title-container">
          <h1 class="challenge-title">{challenge.title}</h1>
          <div class="challenge-meta">
            <div
              class="challenge-creator"
              tabindex="0"
              role="button"
              on:click={goToCreatorProfile}
              on:keydown={(e) => {
                if (e.key === "Enter" || e.key === "Space") {
                  e.preventDefault();
                  goToCreatorProfile();
                }
              }}
            >
              {#if challenge.profiles && challenge.profiles.profile_photo_url}
                <img
                  src={challenge.profiles.profile_photo_url}
                  alt="Creator"
                  class="creator-photo"
                />
              {:else}
                <div class="creator-placeholder">
                  {challenge.profiles ? challenge.profiles.username[0] : "?"}
                </div>
              {/if}
              <span class="creator-name"
                >@{challenge.profiles
                  ? challenge.profiles.username
                  : "unknown"}</span
              >
            </div>

            {#if timeLeft}
              <div class="countdown">
                <span>{timeLeft}</span>
              </div>
            {/if}
          </div>
        </div>
      </div>

      <!-- Tab navigation -->
      <div class="tab-navigation">
        <button
          class="tab-button"
          class:active={tabSelection === "details"}
          on:click={() => (tabSelection = "details")}
        >
          Details
        </button>
        <button
          class="tab-button"
          class:active={tabSelection === "tasks"}
          on:click={() => (tabSelection = "tasks")}
        >
          Tasks
        </button>
        <button
          class="tab-button"
          class:active={tabSelection === "leaderboard"}
          on:click={() => (tabSelection = "leaderboard")}
        >
          Leaderboard
        </button>
        <button
          class="tab-button"
          class:active={tabSelection === "social"}
          on:click={() => (tabSelection = "social")}
        >
          Social
        </button>
      </div>
    </div>

    <!-- Tab content -->
    <div class="tab-content">
      <!-- Details Tab -->
      {#if tabSelection === "details"}
        <div class="challenge-details-tab">
          <div class="detail-card">
            <h2>Challenge Details</h2>
            <table class="details-table">
              <tbody>
                <!-- Added <tbody> -->
                <tr>
                  <th>Type</th>
                  <td>{challenge.type}</td>
                </tr>
                <tr>
                  <th>Participants</th>
                  <td>
                    {challenge.participants_current ||
                      0}/{challenge.participants_max === 0
                      ? "∞"
                      : challenge.participants_max}
                  </td>
                </tr>
                <tr>
                  <th>Buy-in</th>
                  <td>${challenge.buy_in_cost.toFixed(2)}</td>
                </tr>
                <tr>
                  <th>Prize Pool</th>
                  <td>${challenge.prize_pool.toFixed(2)}</td>
                </tr>
                <tr>
                  <th>Scoring</th>
                  <td>{challenge.scoring_type}</td>
                </tr>
                <tr>
                  <th>Access</th>
                  <td>{challenge.is_private ? "Private" : "Public"}</td>
                </tr>
                <tr>
                  <th>Start</th>
                  <td>{formatDate(challenge.start_datetime)}</td>
                </tr>
                <tr>
                  <th>End</th>
                  <td>{formatDate(challenge.end_datetime)}</td>
                </tr>
              </tbody>
              <!-- Added </tbody> -->
            </table>
          </div>

          <div class="action-buttons">
            {#if !$user || !contestants.some((c) => c.user_id === $user.id)}
              <button class="join-button" on:click={joinChallenge}
                >Join Challenge</button
              >
            {/if}

            {#if $user && $user.id === challenge.creator_id && new Date() < new Date(challenge.start_datetime)}
              <button class="edit-button" on:click={toggleEdit}
                >Edit Challenge</button
              >
              <button class="cancel-button" on:click={cancelChallenge}
                >Cancel Challenge</button
              >
            {/if}
          </div>
        </div>
      {/if}

      <!-- Tasks Tab -->
      {#if tabSelection === "tasks"}
        <div class="challenge-tasks-tab">
          <div class="tasks-header">
            <h2>Challenge Tasks</h2>
            {#if $user && $user.id === challenge.creator_id}
              <button class="add-task-button" on:click={toggleTaskCreation}>
                <span class="plus-icon">+</span> Add Task
              </button>
            {/if}
          </div>

          {#if tasks.length > 0}
            <ul class="tasks-list">
              {#each tasks as task, index}
                <li class="task-item">
                  <div class="task-content">
                    <div class="task-number">{index + 1}</div>
                    <div class="task-details">
                      <div class="task-action">{task.action}</div>
                      {#if task.notes}
                        <div class="task-notes">{task.notes}</div>
                      {/if}
                    </div>
                  </div>

                  <div class="task-actions">
                    {#if $user && $user.id === challenge.creator_id && new Date() < new Date(challenge.start_datetime)}
                      <button
                        class="task-edit-btn"
                        on:click={() => editTask(task.id)}>Edit</button
                      >
                      <button
                        class="task-remove-btn"
                        on:click={() => removeTask(task.id)}>Remove</button
                      >
                    {/if}
                    {#if $user && contestants.some((c) => c.user_id === $user.id)}
                      <button
                        class="task-complete-btn"
                        on:click={() => handleCompleteTask(task.id)}
                        >Complete</button
                      >
                    {/if}
                  </div>
                </li>
              {/each}
            </ul>
          {:else}
            <div class="empty-tasks">
              <p>No tasks have been added to this challenge yet.</p>
            </div>
          {/if}
        </div>
      {/if}

      <!-- Leaderboard Tab -->
      {#if tabSelection === "leaderboard"}
        <div class="challenge-leaderboard-tab">
          <h2>Leaderboard</h2>

          {#if contestants.length > 0}
            <div class="leaderboard-container">
              <div class="leaderboard-header">
                <span class="rank-column">Rank</span>
                <span class="user-column">Participant</span>
                <span class="score-column">{getScoreLabel()}</span>
              </div>

              <ul class="leaderboard-list">
                {#each contestants as contestant, index}
                  <li
                    class="leaderboard-item"
                    class:current-user={$user &&
                      contestant.user_id === $user.id}
                  >
                    <div class="rank-badge">
                      {#if index < 3}
                        <div class="top-rank rank-{index + 1}">{index + 1}</div>
                      {:else}
                        <div class="normal-rank">{index + 1}</div>
                      {/if}
                    </div>

                    <div class="contestant-info">
                      {#if contestant.profile_photo_url}
                        <img
                          src={contestant.profile_photo_url}
                          alt={contestant.username}
                          class="contestant-photo"
                        />
                      {:else}
                        <div class="contestant-photo-placeholder">
                          {contestant.username[0]}
                        </div>
                      {/if}
                      <span class="contestant-name">@{contestant.username}</span
                      >
                    </div>

                    <div class="contestant-score">{contestant.score}</div>
                  </li>
                {/each}
              </ul>
            </div>
          {:else}
            <div class="empty-leaderboard">
              <p>No participants have joined this challenge yet.</p>
              <button on:click={joinChallenge}>Be the first to join!</button>
            </div>
          {/if}
        </div>
      {/if}

      <!-- Social Tab -->
      {#if tabSelection === "social"}
        <div class="challenge-social-tab">
          <h2>#{challenge.title} Community</h2>
          <SocialFeed {challengeId} challengeName={challenge.title} />
        </div>
      {/if}
    </div>

    <!-- Modals and Fixed Elements -->
    {#if showTaskCreation}
      <div class="modal-overlay">
        <TaskCreation
          {challengeId}
          task={editingTaskId
            ? tasks.find((t) => t.id === editingTaskId)
            : null}
          editMode={!!editingTaskId}
          on:taskCreated={handleTaskCreated}
          on:close={toggleTaskCreation}
        />
      </div>
    {/if}

    {#if $showChallengeCreation}
      <ChallengeCreation {challenge} editMode={true} />
    {/if}

    {#if showForm}
      <div
        class="modal-overlay"
        on:click={closeForm}
        on:keydown={(e) => e.key === "Escape" && closeForm()}
        role="presentation"
      >
        <TaskCompletionForm
          preSelectedChallengeId={challengeId}
          preSelectedTaskId={selectedTaskId}
          on:close={closeForm}
        />
      </div>
    {/if}

    <!-- Bottom Navigation -->
    <BottomNav {notificationCount} />
  {/if}
</div>

<style>
  .challenge-details-page {
    min-height: 100vh;
    padding-top: 60px; /* For fixed header */
    padding-bottom: 60px; /* For bottom nav */
    background-color: var(--background);
  }

  .loading-container,
  .error-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    min-height: 60vh;
    padding: 20px;
  }

  .error-message {
    color: var(--error);
    margin-bottom: 16px;
    text-align: center;
  }

  .retry-button {
    background-color: var(--tomato);
    color: white;
    padding: 8px 16px;
    border-radius: 8px;
    border: none;
    font-weight: 500;
  }

  /* Challenge Header */
  .challenge-header {
    position: sticky;
    top: 60px; /* Accounting for the main app header */
    z-index: 10;
    background-color: white;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }

  .challenge-cover {
    position: relative;
    width: 100%;
    height: 200px;
    overflow: hidden;
  }

  .cover-image,
  .cover-video {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  .cover-placeholder {
    width: 100%;
    height: 100%;
    background: linear-gradient(
      135deg,
      var(--carolina-blue),
      var(--lapis-lazuli)
    );
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .cover-placeholder span {
    font-size: 4rem;
    font-weight: bold;
    color: white;
    text-transform: uppercase;
  }

  .challenge-title-container {
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;
    padding: 16px;
    background: linear-gradient(to top, rgba(0, 0, 0, 0.8), rgba(0, 0, 0, 0));
    color: white;
  }

  .challenge-title {
    margin: 0 0 8px;
    font-size: 1.5rem;
    font-weight: 700;
    text-shadow: 0 1px 2px rgba(0, 0, 0, 0.5);
  }

  .challenge-meta {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .challenge-creator {
    display: flex;
    align-items: center;
    gap: 8px;
    cursor: pointer;
  }

  .creator-photo,
  .creator-placeholder {
    width: 24px;
    height: 24px;
    border-radius: 50%;
    border: 2px solid white;
  }

  .creator-placeholder {
    background-color: var(--tomato);
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 12px;
    font-weight: bold;
  }

  .creator-name {
    font-size: 14px;
    font-weight: 500;
  }

  .countdown {
    font-size: 14px;
    font-weight: 600;
    color: white;
    background-color: rgba(0, 0, 0, 0.5);
    padding: 4px 8px;
    border-radius: 4px;
  }

  /* Tab Navigation */
  .tab-navigation {
    display: flex;
    border-bottom: 1px solid var(--light-gray);
    overflow-x: auto;
    scrollbar-width: none; /* Firefox */
    -ms-overflow-style: none; /* IE and Edge */
  }

  .tab-navigation::-webkit-scrollbar {
    display: none; /* Chrome, Safari, Opera */
  }

  .tab-button {
    flex: 1;
    min-width: 80px;
    padding: 12px 8px;
    background: none;
    border: none;
    border-bottom: 3px solid transparent;
    font-size: 14px;
    font-weight: 500;
    color: var(--text-secondary);
    cursor: pointer;
    transition: all 0.2s ease;
  }

  .tab-button.active {
    color: var(--tomato);
    border-bottom-color: var(--tomato);
  }

  /* Tab Content */
  .tab-content {
    padding: 16px;
    min-height: 50vh;
  }

  /* Details Tab */
  .challenge-details-tab {
    display: flex;
    flex-direction: column;
    gap: 16px;
  }

  .detail-card {
    background-color: white;
    border-radius: 12px;
    padding: 16px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  }

  .detail-card h2 {
    margin: 0 0 16px;
    font-size: 1.2rem;
    color: var(--text);
  }

  .details-table {
    width: 100%;
    border-collapse: collapse;
  }

  .details-table th,
  .details-table td {
    padding: 8px 0;
    text-align: left;
    border-bottom: 1px solid var(--light-gray);
    font-size: 14px;
  }

  .details-table th {
    width: 40%;
    font-weight: 500;
    color: var(--text-secondary);
  }

  .details-table td {
    color: var(--text);
  }

  .action-buttons {
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
  }

  .join-button {
    flex: 1;
    padding: 12px;
    background-color: var(--tomato);
    color: white;
    border: none;
    border-radius: 8px;
    font-weight: 600;
    font-size: 16px;
    text-align: center;
    cursor: pointer;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }

  .edit-button {
    flex: 1;
    padding: 12px;
    background-color: var(--carolina-blue);
    color: white;
    border: none;
    border-radius: 8px;
    font-weight: 600;
    font-size: 16px;
    text-align: center;
    cursor: pointer;
  }

  .cancel-button {
    flex: 1;
    padding: 12px;
    background-color: var(--gray);
    color: white;
    border: none;
    border-radius: 8px;
    font-weight: 600;
    font-size: 16px;
    text-align: center;
    cursor: pointer;
  }

  /* Tasks Tab */
  .challenge-tasks-tab {
    display: flex;
    flex-direction: column;
    gap: 16px;
  }

  .tasks-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 8px;
  }

  .tasks-header h2 {
    margin: 0;
    font-size: 1.2rem;
  }

  .add-task-button {
    background-color: var(--tomato);
    color: white;
    border: none;
    border-radius: 8px;
    padding: 8px 12px;
    font-size: 14px;
    font-weight: 500;
    display: flex;
    align-items: center;
    gap: 4px;
  }

  .plus-icon {
    font-weight: bold;
  }

  .tasks-list {
    list-style: none;
    padding: 0;
    margin: 0;
    display: flex;
    flex-direction: column;
    gap: 8px;
  }

  .task-item {
    background-color: white;
    border-radius: 12px;
    padding: 12px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  }

  .task-content {
    display: flex;
    gap: 12px;
    margin-bottom: 8px;
  }

  .task-number {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 28px;
    height: 28px;
    background-color: var(--light-gray);
    border-radius: 50%;
    font-size: 14px;
    font-weight: 600;
    color: var(--text);
  }

  .task-details {
    flex: 1;
  }

  .task-action {
    font-size: 16px;
    font-weight: 500;
    color: var(--text);
    margin-bottom: 4px;
  }

  .task-notes {
    font-size: 14px;
    color: var(--text-secondary);
  }

  .task-actions {
    display: flex;
    justify-content: flex-end;
    gap: 8px;
  }

  .task-edit-btn,
  .task-remove-btn,
  .task-complete-btn {
    padding: 6px 12px;
    border: none;
    border-radius: 6px;
    font-size: 12px;
    font-weight: 500;
    cursor: pointer;
  }

  .task-edit-btn {
    background-color: var(--carolina-blue);
    color: white;
  }

  .task-remove-btn {
    background-color: var(--gray);
    color: white;
  }

  .task-complete-btn {
    background-color: var(--tomato);
    color: white;
  }

  .empty-tasks {
    text-align: center;
    padding: 24px;
    color: var(--text-secondary);
    background-color: white;
    border-radius: 12px;
  }

  /* Leaderboard Tab */
  .challenge-leaderboard-tab {
    display: flex;
    flex-direction: column;
    gap: 16px;
  }

  .challenge-leaderboard-tab h2 {
    margin: 0;
    font-size: 1.2rem;
  }

  .leaderboard-container {
    background-color: white;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  }

  .leaderboard-header {
    display: flex;
    padding: 12px 16px;
    background-color: var(--light-gray);
    font-size: 14px;
    font-weight: 500;
    color: var(--text-secondary);
  }

  .rank-column {
    width: 60px;
    text-align: center;
  }

  .user-column {
    flex: 1;
  }

  .score-column {
    width: 80px;
    text-align: right;
  }

  .leaderboard-list {
    list-style: none;
    padding: 0;
    margin: 0;
  }

  .leaderboard-item {
    display: flex;
    align-items: center;
    padding: 12px 16px;
    border-bottom: 1px solid var(--light-gray);
  }

  .leaderboard-item.current-user {
    background-color: rgba(242, 100, 64, 0.05);
  }

  .rank-badge {
    width: 60px;
    display: flex;
    justify-content: center;
  }

  .top-rank {
    width: 28px;
    height: 28px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 600;
    font-size: 14px;
    color: white;
  }

  .rank-1 {
    background-color: gold;
  }

  .rank-2 {
    background-color: silver;
  }

  .rank-3 {
    background-color: #cd7f32; /* bronze */
  }

  .normal-rank {
    width: 28px;
    height: 28px;
    border-radius: 50%;
    background-color: var(--light-gray);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 14px;
    color: var(--text);
  }

  .contestant-info {
    flex: 1;
    display: flex;
    align-items: center;
    gap: 8px;
  }

  .contestant-photo,
  .contestant-photo-placeholder {
    width: 36px;
    height: 36px;
    border-radius: 50%;
  }

  .contestant-photo-placeholder {
    background-color: var(--carolina-blue);
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 16px;
    font-weight: 500;
  }

  .contestant-name {
    font-size: 14px;
    font-weight: 500;
    color: var(--text);
  }

  .contestant-score {
    width: 80px;
    text-align: right;
    font-size: 16px;
    font-weight: 600;
    color: var(--text);
  }

  .empty-leaderboard {
    text-align: center;
    padding: 24px;
    background-color: white;
    border-radius: 12px;
  }

  .empty-leaderboard p {
    color: var(--text-secondary);
    margin-bottom: 16px;
  }

  .empty-leaderboard button {
    background-color: var(--tomato);
    color: white;
    border: none;
    border-radius: 8px;
    padding: 8px 16px;
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
  }

  /* Social Tab */
  .challenge-social-tab {
    display: flex;
    flex-direction: column;
    gap: 16px;
  }

  .challenge-social-tab h2 {
    margin: 0;
    font-size: 1.2rem;
  }

  /* Modal overlay */
  .modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(0, 0, 0, 0.5);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 1000;
  }

  /* Responsive adjustments */
  @media (min-width: 768px) {
    .tab-content {
      max-width: 800px;
      margin: 0 auto;
    }

    .challenge-cover {
      height: 300px;
    }

    .challenge-title {
      font-size: 2rem;
    }

    .action-buttons {
      flex-direction: row;
    }
  }
</style>
