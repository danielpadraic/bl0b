<script>
  import { onMount } from "svelte";
  import { createEventDispatcher } from "svelte";
  import { supabase } from "../supabase.js"; // Adjust path if different

  const dispatch = createEventDispatcher();

  // Form state
  let showForm = false;
  let title = "";
  let type = "Fitness";
  let customType = "";
  let maxParticipants = null;
  let allowLateJoins = false;
  let startDate = new Date().toISOString().slice(0, 16); // For datetime-local
  let endDate = new Date().toISOString().slice(0, 16);
  let joinCost = 0.0;
  let prizeDistribution = "even";
  let scoringSystem = "points";
  let customScoring = "";
  let isPublic = true;
  let tasks = [{ description: "", pointValue: 0, verificationMethod: "none" }];
  let challengeTypes = ["Fitness", "Other"];

  // Fetch challenge types from Supabase
  async function fetchChallengeTypes() {
    const { data, error } = await supabase
      .from("challenge_types")
      .select("name")
      .order("usage_count", { ascending: false })
      .limit(5); // Top 5 most used types
    if (!error) {
      challengeTypes = [
        "Fitness",
        ...data.map((d) => d.name).filter((n) => n !== "Fitness"),
        "Other",
      ];
    } else {
      console.error("Error fetching challenge types:", error);
    }
  }

  onMount(fetchChallengeTypes);

  // Add a new task
  function addTask() {
    tasks = [
      ...tasks,
      { description: "", pointValue: 0, verificationMethod: "none" },
    ];
  }

  // Remove a task
  function removeTask(index) {
    tasks = tasks.filter((_, i) => i !== index);
  }

  // Handle form submission
  async function createChallenge(e) {
    e.preventDefault();

    let typeId;
    if (type === "Other" && customType) {
      const { data, error } = await supabase
        .from("challenge_types")
        .insert([{ name: customType }])
        .select("id")
        .single();
      if (error) {
        console.error("Error creating challenge type:", error);
        return;
      }
      typeId = data.id;
    } else {
      const { data, error } = await supabase
        .from("challenge_types")
        .select("id")
        .eq("name", type)
        .single();
      if (error) {
        console.error("Error finding challenge type:", error);
        return;
      }
      typeId = data.id;
    }

    await supabase.rpc("increment_usage_count", { type_id: typeId });

    const challengeData = {
      title,
      type_id: typeId,
      max_participants: maxParticipants || null,
      allow_late_joins: allowLateJoins,
      start_date: new Date(startDate).toISOString(),
      end_date: new Date(endDate).toISOString(),
      join_cost: parseFloat(joinCost),
      prize_distribution: { type: prizeDistribution },
      scoring_system:
        scoringSystem === "custom"
          ? { type: "custom", details: customScoring }
          : { type: scoringSystem },
      is_public: isPublic,
      created_by: (await supabase.auth.getUser()).data.user.id,
    };

    const { data: challenge, error: challengeError } = await supabase
      .from("challenges")
      .insert([challengeData])
      .select()
      .single();
    if (challengeError) {
      console.error("Error creating challenge:", challengeError);
      return;
    }

    const taskInserts = tasks.map((task) => ({
      challenge_id: challenge.id,
      description: task.description,
      point_value: task.pointValue || 0,
      verification_method: task.verificationMethod,
    }));
    const { error: taskError } = await supabase
      .from("tasks")
      .insert(taskInserts);
    if (taskError) {
      console.error("Error creating tasks:", taskError);
      return;
    }

    showForm = false;
    resetForm();
    dispatch("challengeCreated", challenge);
  }

  // Reset form fields
  function resetForm() {
    title = "";
    type = "Fitness";
    customType = "";
    maxParticipants = null;
    allowLateJoins = false;
    startDate = new Date().toISOString().slice(0, 16);
    endDate = new Date().toISOString().slice(0, 16);
    joinCost = 0.0;
    prizeDistribution = "even";
    scoringSystem = "points";
    customScoring = "";
    isPublic = true;
    tasks = [{ description: "", pointValue: 0, verificationMethod: "none" }];
  }

  // Toggle form visibility with click or Escape key
  function toggleForm(event) {
    if (
      event.type === "click" ||
      (event.type === "keydown" && event.key === "Escape")
    ) {
      showForm = !showForm;
      if (!showForm) resetForm();
    }
  }
</script>

<!-- Trigger button -->
<button on:click={toggleForm}>Create Challenge</button>

<!-- Floating form -->
{#if showForm}
  <div
    class="modal-overlay"
    on:click={toggleForm}
    on:keydown={toggleForm}
    role="dialog"
    aria-modal="true"
    tabindex="0"
  >
    <div class="modal-content" on:click|stopPropagation>
      <h2>Create a Challenge</h2>
      <form on:submit={createChallenge}>
        <!-- Title -->
        <label>
          Title:
          <input type="text" bind:value={title} required />
        </label>

        <!-- Type -->
        <label>
          Type:
          <select bind:value={type}>
            {#each challengeTypes as challengeType}
              <option value={challengeType}>{challengeType}</option>
            {/each}
          </select>
          {#if type === "Other"}
            <input
              type="text"
              bind:value={customType}
              placeholder="Custom Type"
              required
            />
          {/if}
        </label>

        <!-- Participants -->
        <label>
          Max Participants (optional):
          <input type="number" bind:value={maxParticipants} min="1" />
        </label>
        <label>
          Allow Late Joins:
          <input type="checkbox" bind:checked={allowLateJoins} />
        </label>

        <!-- Dates -->
        <label>
          Start Date:
          <input type="datetime-local" bind:value={startDate} required />
        </label>
        <label>
          End Date:
          <input type="datetime-local" bind:value={endDate} required />
        </label>

        <!-- Join Cost -->
        <label>
          Join Cost ($):
          <input type="number" bind:value={joinCost} step="0.01" min="0" />
        </label>

        <!-- Prize Distribution -->
        <label>
          Prize Distribution:
          <select bind:value={prizeDistribution}>
            <option value="even">Even Split</option>
            <option value="tournament">Tournament Style</option>
          </select>
        </label>

        <!-- Scoring System -->
        <label>
          Scoring System:
          <select bind:value={scoringSystem}>
            <option value="points">Points</option>
            {#if type === "Fitness"}
              <option value="duration">Duration</option>
              <option value="distance">Distance</option>
              <option value="consistency">Consistency</option>
              <option value="weight_loss">Weight Loss</option>
            {/if}
            <option value="custom">Custom</option>
          </select>
          {#if scoringSystem === "custom"}
            <input
              type="text"
              bind:value={customScoring}
              placeholder="Custom Scoring Details"
              required
            />
          {/if}
        </label>

        <!-- Privacy -->
        <label>
          Privacy:
          <select bind:value={isPublic}>
            <option value={true}>Public</option>
            <option value={false}>Private</option>
          </select>
        </label>

        <!-- Tasks -->
        <h3>Tasks</h3>
        {#each tasks as task, i}
          <div class="task">
            <label>
              Description:
              <input type="text" bind:value={task.description} required />
            </label>
            <label>
              Point Value:
              <input type="number" bind:value={task.pointValue} min="0" />
            </label>
            <label>
              Verification Method:
              <select bind:value={task.verificationMethod}>
                <option value="none">None</option>
                <option value="photo">Photo Upload</option>
                <option value="time">Time Entry</option>
                <option value="distance">Distance Entry</option>
              </select>
            </label>
            {#if tasks.length > 1}
              <button type="button" on:click={() => removeTask(i)}
                >Remove</button
              >
            {/if}
          </div>
        {/each}
        <button type="button" on:click={addTask}>Add Task</button>

        <!-- Submit -->
        <button type="submit">Create Challenge</button>
      </form>
      <button on:click={toggleForm}>Close</button>
    </div>
  </div>
{/if}

<style>
  .modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 1000;
  }

  .modal-content {
    background: white;
    padding: 20px;
    border-radius: 8px;
    max-width: 500px;
    width: 90%;
    max-height: 80vh;
    overflow-y: auto;
  }

  form {
    display: flex;
    flex-direction: column;
    gap: 10px;
  }

  label {
    display: flex;
    flex-direction: column;
    gap: 5px;
  }

  input,
  select {
    padding: 8px;
    border: 1px solid #ddd;
    border-radius: 4px;
  }

  .task {
    border: 1px solid #eee;
    padding: 10px;
    margin-bottom: 10px;
    border-radius: 4px;
  }

  button {
    background-color: #ff6347;
    color: white;
    border: none;
    padding: 8px 16px;
    border-radius: 4px;
    cursor: pointer;
  }

  button:hover {
    background-color: #ff8566;
  }
</style>
