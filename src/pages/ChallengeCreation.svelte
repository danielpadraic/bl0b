<script>
  import { onMount } from "svelte";
  import { supabase } from "../supabase.js"; // Adjust path as needed
  import { user } from "../stores.js"; // Adjust path as needed
  import TaskCreation from "./TaskCreation.svelte";

  export let challengeId;

  let challenge = null;
  let tasks = [];
  let loading = true;
  let error = null;
  let showTaskCreation = false;

  onMount(async () => {
    await fetchChallengeDetails();
    if (challenge) {
      await fetchTasks();
    }
    loading = false;
  });

  async function fetchChallengeDetails() {
    const { data, error: fetchError } = await supabase
      .from("challenges")
      .select("*")
      .eq("id", challengeId)
      .single();
    if (fetchError) {
      error = fetchError.message;
    } else {
      challenge = data;
    }
  }

  async function fetchTasks() {
    const { data, error: fetchError } = await supabase
      .from("tasks")
      .select("*")
      .eq("challenge_id", challengeId)
      .order("created_at", { ascending: true });
    if (fetchError) {
      error = fetchError.message;
    } else {
      tasks = data;
    }
  }

  function handleTaskCreated() {
    fetchTasks(); // Refresh task list
  }

  function toggleTaskCreation() {
    showTaskCreation = !showTaskCreation;
  }

  // Placeholder for edit functionality
  function editTask(taskId) {
    console.log("Edit task:", taskId);
    // Add edit form logic here (e.g., open a similar popup with pre-filled data)
  }
</script>

<div class="challenge-details">
  {#if loading}
    <p>Loading...</p>
  {:else if error}
    <p class="error">Error: {error}</p>
  {:else if challenge}
    <!-- Existing Challenge Details (e.g., title, description) -->
    <h1>{challenge.title}</h1>
    <p>{challenge.description}</p>

    {#if $user && $user.id === challenge.creator_id && new Date() < new Date(challenge.start_datetime)}
      <button on:click={toggleTaskCreation}>Add Task</button>
    {/if}

    {#if showTaskCreation}
      <TaskCreation
        {challengeId}
        on:taskCreated={handleTaskCreated}
        on:close={toggleTaskCreation}
      />
    {/if}

    <div class="tasks">
      <h2>Tasks</h2>
      {#if tasks.length > 0}
        <ul>
          {#each tasks as task}
            <li>
              <strong>{task.action}</strong> - {task.frequency} - {task.data_type}
              {#if task.notes}
                <p>{task.notes}</p>
              {/if}
              {#if $user && $user.id === challenge.creator_id && new Date() < new Date(challenge.start_datetime)}
                <button on:click={() => editTask(task.id)}>Edit</button>
              {/if}
            </li>
          {/each}
        </ul>
      {:else}
        <p>No tasks yet.</p>
      {/if}
    </div>
  {/if}
</div>

<style>
  .challenge-details {
    padding: 2rem;
    max-width: 800px;
    margin: 0 auto;
  }

  h1 {
    font-size: 2rem;
    color: #333;
  }

  .error {
    color: #e74c3c;
  }

  button {
    padding: 0.5rem 1rem;
    background-color: #e74c3c;
    color: #fff;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.3s;
  }

  button:hover {
    background-color: #c0392b;
  }

  .tasks {
    margin-top: 2rem;
  }

  .tasks ul {
    list-style: none;
    padding: 0;
  }

  .tasks li {
    background: #f9f9f9;
    padding: 1rem;
    margin-bottom: 1rem;
    border-radius: 8px;
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
  }

  .tasks li strong {
    font-size: 1.1rem;
    color: #333;
  }

  .tasks li p {
    margin: 0.5rem 0;
    color: #666;
  }

  .tasks li button {
    padding: 0.25rem 0.5rem;
    font-size: 0.9rem;
    margin-left: 1rem;
  }
</style>
