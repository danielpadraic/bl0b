<script>
  import { createEventDispatcher, onMount } from "svelte";
  import { supabase } from "../supabase.js";

  export let challengeId;
  export let task = null;
  export let editMode = false;

  const dispatch = createEventDispatcher();

  let action = "";
  let frequency = "";
  let customValue = "";
  let customUnit = "days";
  let verificationType = "";
  let notes = "";
  let requireAttachment = false;
  let errorMessage = "";

  onMount(() => {
    console.log("TaskCreation mounted. editMode:", editMode, "task:", task);
    if (editMode && task) {
      console.log("Populating task form with:", task);
      action = task.action || "";
      frequency = task.frequency.startsWith("Every")
        ? "Custom"
        : task.frequency;
      if (frequency === "Custom") {
        const [_, value, unit] = task.frequency.split(" ");
        customValue = value || "";
        customUnit = unit || "days";
      }
      verificationType = task.verification_type || "";
      notes = task.notes || "";
      requireAttachment = task.require_attachment || false;
      console.log("Task fields set:", {
        action,
        frequency,
        verificationType,
        requireAttachment,
      });
    }
  });

  async function saveTask(event) {
    event.preventDefault();
    console.log("saveTask called with:", {
      action,
      frequency,
      verificationType,
      requireAttachment,
      notes,
    });

    if (!action || !frequency || !verificationType) {
      errorMessage = "Please fill in all required fields.";
      console.log("Validation failed:", errorMessage);
      return false;
    }

    let finalFrequency = frequency;
    if (frequency === "Custom") {
      if (!customValue || isNaN(customValue) || customValue <= 0) {
        errorMessage = "Please enter a valid number for custom frequency.";
        console.log("Custom frequency validation failed:", errorMessage);
        return false;
      }
      finalFrequency = `Every ${customValue} ${customUnit}`;
    }

    const taskData = {
      challenge_id: challengeId,
      action,
      frequency: finalFrequency,
      verification_type: verificationType,
      notes,
      require_attachment: requireAttachment,
    };

    console.log("Saving task to Supabase:", taskData);
    let result;
    if (editMode && task) {
      result = await supabase
        .from("tasks")
        .update(taskData)
        .eq("id", task.id)
        .select()
        .single();
    } else {
      result = await supabase
        .from("tasks")
        .insert([taskData])
        .select()
        .single();
    }

    const { data, error } = result;
    if (error) {
      errorMessage = error.message;
      console.error("Supabase error:", errorMessage);
      return false;
    }

    console.log("Task saved successfully:", data);
    dispatch("taskCreated");
    resetForm();
    return true;
  }

  function resetForm() {
    action = "";
    frequency = "";
    customValue = "";
    customUnit = "days";
    verificationType = "";
    notes = "";
    requireAttachment = false;
    errorMessage = "";
  }

  async function closeAndSave() {
    console.log("closeAndSave called");
    const success = await saveTask({ preventDefault: () => {} });
    if (success) {
      console.log("Task saved, closing modal");
      dispatch("close");
    } else {
      console.log("Task save failed, modal remains open");
    }
  }

  function close() {
    console.log("close called");
    dispatch("close");
  }
</script>

<div class="task-creation">
  <h2>{editMode ? "Edit Task" : "Create Task"}</h2>
  {#if errorMessage}
    <p class="error">{errorMessage}</p>
  {/if}
  <form on:submit={saveTask}>
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
      Verification Type:
      <select bind:value={verificationType} required>
        <option value="">Select Verification Type</option>
        <option value="Text Form">Text Form</option>
        <option value="Time Entry">Time Entry</option>
        <option value="Numerical Entry">Numerical Entry</option>
        <option value="No Verification">No Verification</option>
      </select>
    </label>
    <label>
      Require Attachment Upload:
      <div class="toggle-switch">
        <input
          type="checkbox"
          id="requireAttachment"
          bind:checked={requireAttachment}
        />
        <label for="requireAttachment" class="slider"></label>
      </div>
    </label>
    <label>
      Notes:
      <textarea bind:value={notes}></textarea>
    </label>
    <div class="buttons">
      <button type="submit">{editMode ? "Update Task" : "Add Task"}</button>
      {#if editMode}
        <button type="button" on:click={closeAndSave}>Complete</button>
      {/if}
      <button type="button" on:click={close}>Cancel</button>
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

  .toggle-switch {
    position: relative;
    display: inline-block;
    width: 40px;
    height: 20px;
    margin-left: 0.5rem;
    vertical-align: middle;
  }

  .toggle-switch input {
    opacity: 0;
    width: 0;
    height: 0;
  }

  .slider {
    position: absolute;
    cursor: pointer;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: var(--gray);
    transition: 0.4s;
    border-radius: 20px;
  }

  .slider:before {
    position: absolute;
    content: "";
    height: 16px;
    width: 16px;
    left: 2px;
    bottom: 2px;
    background-color: var(--white);
    transition: 0.4s;
    border-radius: 50%;
  }

  input:checked + .slider {
    background-color: var(--tomato);
  }

  input:checked + .slider:before {
    transform: translateX(20px);
  }

  .buttons {
    display: flex;
    justify-content: space-between;
    margin-top: 1rem;
    gap: 0.5rem;
  }

  button {
    padding: 0.5rem 1rem;
    background-color: var(--tomato);
    color: var(--white);
    border: none;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.3s;
    flex: 1;
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
