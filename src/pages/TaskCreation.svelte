<script>
  import { createEventDispatcher } from "svelte";
  import { supabase } from "../supabase.js";

  export let challengeId;

  const dispatch = createEventDispatcher();

  let action = "";
  let frequency = "";
  let customValue = "";
  let customUnit = "days";
  let dataType = "";
  let notes = "";
  let errorMessage = "";

  async function createTask() {
    if (!action || !frequency || !dataType) {
      errorMessage = "Please fill in all required fields.";
      return;
    }

    let finalFrequency = frequency;
    if (frequency === "Custom") {
      if (!customValue || isNaN(customValue) || customValue <= 0) {
        errorMessage = "Please enter a valid number for custom frequency.";
        return;
      }
      finalFrequency = `Every ${customValue} ${customUnit}`;
    }

    const taskData = {
      challenge_id: challengeId,
      action,
      frequency: finalFrequency,
      data_type: dataType,
      notes,
    };

    const { error } = await supabase.from("tasks").insert([taskData]);
    if (error) {
      errorMessage = error.message;
    } else {
      dispatch("taskCreated");
      resetForm();
    }
  }

  function resetForm() {
    action = "";
    frequency = "";
    customValue = "";
    customUnit = "days";
    dataType = "";
    notes = "";
    errorMessage = "";
  }

  function close() {
    dispatch("close");
  }
</script>

<div class="task-creation">
  <h2>Create Task</h2>
  {#if errorMessage}
    <p class="error">{errorMessage}</p>
  {/if}
  <form on:submit|preventDefault={createTask}>
    <label>
      Action:
      <input type="text" bind:value={action} required />
    </label>
    <label>
      Frequency:
      <select bind:value={frequency} required>
        <option value="">Select Frequency</option>
        <option value="per hour">Per Hour</option>
        <option value="per day">Per Day</option>
        <option value="per week">Per Week</option>
        <option value="per month">Per Month</option>
        <option value="per challenge">Per Challenge</option>
        <option value="Custom">Custom</option>
      </select>
    </label>
    {#if frequency === "Custom"}
      <div class="custom-frequency">
        <label>
          Every:
          <input
            type="number"
            bind:value={customValue}
            min="1"
            required
            placeholder="e.g., 5"
          />
          <select bind:value={customUnit} required>
            <option value="minutes">Minutes</option>
            <option value="hours">Hours</option>
            <option value="days">Days</option>
            <option value="weeks">Weeks</option>
            <option value="months">Months</option>
          </select>
        </label>
      </div>
    {/if}
    <label>
      Data Type:
      <select bind:value={dataType} required>
        <option value="">Select Data Type</option>
        <option value="Text Form">Text Form</option>
        <option value="Time Entry">Time Entry</option>
        <option value="Numerical Entry">Numerical Entry</option>
        <option value="Attachment Upload">Attachment Upload</option>
        <option value="No Verification">No Verification</option>
      </select>
    </label>
    <label>
      Notes:
      <textarea bind:value={notes}></textarea>
    </label>
    <div class="buttons">
      <button type="submit">Add Task</button>
      <button type="button" on:click={close}>Complete</button>
    </div>
  </form>
</div>

<style>
  .task-creation {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background: var(--white);
    padding: 1rem;
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
    max-width: 400px;
    width: 90%;
    z-index: 1000;
  }

  h2 {
    margin: 0 0 1rem 0;
    font-size: 1.5rem;
    color: var(--charcoal);
  }

  .error {
    color: var(--tomato);
    margin-bottom: 1rem;
  }

  label {
    display: block;
    margin-bottom: 0.5rem;
    font-size: 0.9rem;
  }

  input,
  select,
  textarea {
    width: 100%;
    padding: 0.5rem;
    margin-top: 0.25rem;
    border: 1px solid var(--light-gray);
    border-radius: 4px;
    font-size: 0.9rem;
  }

  .custom-frequency {
    display: flex;
    gap: 0.5rem;
    margin-top: 0.5rem;
  }

  .custom-frequency input {
    width: 60px;
  }

  .custom-frequency select {
    flex: 1;
  }

  textarea {
    resize: vertical;
    min-height: 100px;
  }

  .buttons {
    display: flex;
    justify-content: space-between;
    margin-top: 1rem;
  }

  button {
    padding: 0.5rem 1rem;
    background-color: var(--tomato);
    color: var(--white);
    border: none;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.3s;
  }

  button:hover {
    background-color: var(--tomato-light);
  }

  button[type="button"] {
    background-color: var(--gray);
  }

  button[type="button"]:hover {
    background-color: var(--light-gray);
  }
</style>
