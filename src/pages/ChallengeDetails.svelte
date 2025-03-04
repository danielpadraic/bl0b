<script>
  import { onMount, onDestroy } from "svelte";
  import { supabase } from "../supabase.js";
  import { user, showChallengeCreation } from "../stores.js"; // Removed showTaskCompletionForm
  import { navigate } from "svelte-routing";
  import TaskCreation from "./TaskCreation.svelte";
  import ChallengeCreation from "./ChallengeCreation.svelte";
  import SocialFeed from "./SocialFeed.svelte";
  import TaskCompletionForm from "./TaskCompletionForm.svelte";

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
  let selectedTaskId = null; // New: Track which task's "Complete" was clicked

  onMount(async () => {
    console.log("ChallengeDetails mounted with challengeId:", challengeId);
    await fetchChallengeDetails();
    if (challenge) {
      await fetchContestants();
      await fetchTasks();
      startCountdown();
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
        .select("*, profiles!challenges_creator_id_fkey(username)")
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
          .select("id, username")
          .in("id", userIds);
        if (profilesError) throw profilesError;

        contestants = data.map((participant) => {
          const profile = profilesData.find(
            (p) => p.id === participant.user_id
          );
          return {
            user_id: participant.user_id,
            username: profile ? profile.username : "Unknown",
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
    selectedTaskId = taskId; // Set the specific task ID
    showForm = true; // Show local form only
  }

  function closeForm() {
    showForm = false;
    selectedTaskId = null; // Reset selected task
    fetchTasks(); // Refresh tasks after submission
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
</script>

<div class="challenge-details">
  {#if loading}
    <p>Loading...</p>
  {:else if error}
    <p class="error">Error: {error}</p>
  {:else if challenge}
    <div class="header-section">
      <h1>Challenge Details</h1>
      {#if $user && $user.id === challenge.creator_id && new Date() < new Date(challenge.start_datetime)}
        <button class="edit-btn" on:click={toggleEdit}>Edit Challenge</button>
      {/if}
      <div class="header-table">
        <table>
          <tr><th>Title</th><td>{challenge.title}</td></tr>
          <tr><th>Type</th><td>{challenge.type}</td></tr>
          <tr>
            <th>Participants</th>
            <td>
              {challenge.participants_current ||
                0}/{challenge.participants_max === 0
                ? "∞"
                : challenge.participants_max}
            </td>
          </tr>
          <tr><th>Cost</th><td>${challenge.buy_in_cost.toFixed(2)}</td></tr>
          <tr><th>Prize</th><td>${challenge.prize_pool.toFixed(2)}</td></tr>
          <tr><th>Scoring</th><td>{challenge.scoring_type}</td></tr>
          <tr
            ><th>Access</th><td
              >{challenge.is_private ? "Private" : "Public"}</td
            ></tr
          >
          <tr
            ><th>Creator</th><td>{challenge.profiles.username || "Unknown"}</td
            ></tr
          >
          <tr>
            <th>Start</th>
            <td>
              {challenge.start_datetime
                ? new Date(challenge.start_datetime).toLocaleString()
                : "Not set"}
            </td>
          </tr>
          <tr>
            <th>End</th>
            <td>
              {challenge.end_datetime
                ? new Date(challenge.end_datetime).toLocaleString()
                : "Not set"}
            </td>
          </tr>
        </table>
      </div>
      {#if timeLeft}
        <div class="countdown">
          <span>Time Left: {timeLeft}</span>
        </div>
      {/if}
      {#if $user && $user.id === challenge.creator_id}
        <div class="action-buttons">
          <button class="add-task-btn" on:click={toggleTaskCreation}
            >Add Task</button
          >
          <button class="cancel-btn" on:click={cancelChallenge}
            >Cancel Challenge</button
          >
        </div>
      {/if}
    </div>

    {#if showTaskCreation}
      <TaskCreation
        {challengeId}
        task={editingTaskId ? tasks.find((t) => t.id === editingTaskId) : null}
        editMode={!!editingTaskId}
        on:taskCreated={handleTaskCreated}
        on:close={toggleTaskCreation}
      />
    {/if}
    {#if $showChallengeCreation}
      <ChallengeCreation {challenge} editMode={true} />
    {/if}

    <div class="tasks">
      <h2>Tasks</h2>
      {#if tasks.length > 0}
        <ul class="task-list">
          {#each tasks as task, index}
            <li>
              {index + 1}. {task.action}
              {#if $user && $user.id === challenge.creator_id && new Date() < new Date(challenge.start_datetime)}
                <button class="edit-task-btn" on:click={() => editTask(task.id)}
                  >Edit</button
                >
                <button
                  class="remove-task-btn"
                  on:click={() => removeTask(task.id)}>Remove</button
                >
              {/if}
              {#if !task.completed}
                <button on:click={() => handleCompleteTask(task.id)}
                  >Complete</button
                >
              {/if}
            </li>
          {/each}
        </ul>
      {:else}
        <p>No tasks yet.</p>
      {/if}
    </div>

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

    {#if challenge.cover_media}
      <div class="cover-container">
        {#if challenge.cover_media.match(/\.(jpg|jpeg|png|gif)$/i)}
          <img src={challenge.cover_media} alt="Challenge Cover" />
        {:else if challenge.cover_media.match(/\.(mp4|webm)$/i)}
          <video controls src={challenge.cover_media}>
            <track kind="captions" label="No captions available" />
          </video>
        {/if}
      </div>
    {/if}

    <div class="contestants">
      <h2>Contestants</h2>
      {#if contestants.length > 0}
        <table class="contestants-table">
          <thead>
            <tr>
              <th>Rank</th>
              <th>Username</th>
              <th>{getScoreLabel()}</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            {#each contestants as contestant, index}
              <tr>
                <td>{index + 1}</td>
                <td>{contestant.username}</td>
                <td>{contestant.score}</td>
                <td>Active</td>
              </tr>
            {/each}
          </tbody>
        </table>
      {:else}
        <p>No contestants yet.</p>
      {/if}
      {#if !$user || !contestants.some((c) => c.user_id === $user.id)}
        <button on:click={joinChallenge}>Join Challenge</button>
      {/if}
    </div>

    <div class="social-feed-container">
      <h2>#{challenge.title} Community</h2>
      <SocialFeed {challengeId} challengeName={challenge.title} />
    </div>
  {/if}
</div>

<style>
  .challenge-details {
    padding: 2rem;
    max-width: 900px;
    margin: 0 auto;
    background: linear-gradient(145deg, var(--background), var(--light-gray));
    color: var(--text);
    border-radius: 12px;
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
  }
  .header-section {
    text-align: center;
    margin-bottom: 2rem;
  }
  h1 {
    font-size: 1.5rem;
    color: var(--charcoal);
    text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1);
    margin-bottom: 1.5rem;
  }
  .edit-btn,
  .add-task-btn,
  .cancel-btn {
    background-color: var(--carolina-blue);
    color: var(--white);
    padding: 0.5rem 1rem;
    border-radius: 6px;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    margin: 0.5rem;
  }
  .edit-btn:hover,
  .add-task-btn:hover,
  .cancel-btn:hover {
    background-color: #87ceeb;
    transform: translateY(-2px);
  }
  .cancel-btn {
    background-color: #e74c3c;
  }
  .cancel-btn:hover {
    background-color: #c0392b;
  }
  .header-table table {
    border-collapse: collapse;
    background: var(--white);
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  }
  .header-table th,
  .header-table td {
    padding: 0.25rem 0.5rem;
    border: 1px solid var(--light-gray);
    font-size: 0.9rem;
    white-space: nowrap;
    text-align: left;
  }
  .header-table th {
    background: linear-gradient(to bottom, var(--carolina-blue), #87ceeb);
    color: var(--charcoal);
    font-weight: bold;
    text-shadow: 0 1px 1px rgba(255, 255, 255, 0.8);
    width: 25%;
  }
  .header-table td {
    background-color: var(--white);
    color: var(--charcoal);
    width: 75%;
  }
  .action-buttons {
    display: flex;
    justify-content: center;
    gap: 1rem;
    margin-top: 1rem;
  }
  .countdown {
    margin-top: 1rem;
    font-size: 1.2rem;
    color: var(--tomato);
    text-shadow: 0 1px 1px rgba(0, 0, 0, 0.1);
  }
  .cover-container {
    margin: 2rem auto;
    max-width: 700px;
    display: flex;
    justify-content: center;
    align-items: center;
    overflow: hidden;
    border-radius: 8px;
    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.2);
  }
  .cover-container img,
  .cover-container video {
    width: 100%;
    height: auto;
    object-fit: contain;
    transition: transform 0.3s ease;
  }
  .cover-container img:hover,
  .cover-container video:hover {
    transform: scale(1.02);
  }
  .tasks,
  .contestants,
  .social-feed-container {
    margin-top: 2rem;
  }
  h2 {
    font-size: 1.2rem;
    color: var(--charcoal);
    text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1);
    margin-bottom: 1rem;
  }
  .task-list {
    list-style: none;
    padding: 0;
  }
  .task-list li {
    margin-bottom: 0.5rem;
    font-size: 0.9rem;
    color: var(--charcoal);
  }
  .task-list button {
    margin-left: 0.5rem;
    padding: 0.25rem 0.5rem;
    font-size: 0.8rem;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    background-color: var(--tomato);
    color: var(--white);
  }
  .task-list button:hover {
    background-color: var(--tomato-light);
  }
  .edit-task-btn {
    background-color: var(--carolina-blue);
  }
  .edit-task-btn:hover {
    background-color: #87ceeb;
  }
  .remove-task-btn {
    background-color: #e74c3c;
  }
  .remove-task-btn:hover {
    background-color: #c0392b;
  }
  .contestants-table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0;
    background: var(--white);
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  }
  .contestants-table th,
  .contestants-table td {
    padding: 0.75rem;
    border: 1px solid var(--light-gray);
    text-align: left;
    font-size: 0.9rem;
  }
  .contestants-table th {
    background: linear-gradient(to bottom, var(--tomato), var(--tomato-light));
    color: var(--white);
    font-weight: bold;
    text-shadow: 0 1px 1px rgba(0, 0, 0, 0.2);
  }
  .contestants-table td {
    background-color: var(--white);
    color: var(--charcoal);
    transition: background-color 0.3s ease;
  }
  .contestants-table tr:hover td {
    background-color: var(--light-gray);
    box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.05);
  }
  button {
    background-color: var(--tomato);
    color: var(--white);
    border: none;
    padding: 0.75rem 1.5rem;
    border-radius: 6px;
    cursor: pointer;
    font-size: 1rem;
    transition: all 0.3s ease;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    margin-top: 1.5rem;
  }
  button:hover {
    background-color: var(--tomato-light);
    transform: translateY(-2px);
    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.25);
  }
  .modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 2000;
  }
  .error {
    color: var(--tomato);
    font-size: 1.1rem;
    text-align: center;
  }
  .social-feed-container {
    background: var(--white);
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    padding: 1rem;
  }
</style>
