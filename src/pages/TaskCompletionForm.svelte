<script>
  import { onMount } from "svelte";
  import { supabase } from "../supabase.js";
  import { user, showTaskCompletionForm } from "../stores.js";

  export let onClose = () => {};

  let challenges = [];
  let selectedChallenge = null;
  let tasks = [];
  let selectedTask = null;
  let submissionData = { verification: "" };
  let attachments = [];
  let currentUserUsername = "";
  let loadingChallenges = true;
  let loadingTasks = false;
  let error = null;
  let prevSelectedTask = null;

  onMount(async () => {
    if (!$user) {
      error = "Please log in to submit tasks.";
      loadingChallenges = false;
      return;
    }

    try {
      const { data, error: fetchError } = await supabase
        .from("challenge_participants")
        .select("challenge_id, challenges(*)")
        .eq("user_id", $user.id);
      if (fetchError) throw fetchError;
      challenges = data.map((d) => d.challenges).filter((c) => c);
      console.log("Fetched challenges:", challenges);
    } catch (err) {
      console.error("Error fetching challenges:", err);
      error = "Failed to load challenges. Please try again.";
    } finally {
      loadingChallenges = false;
    }

    try {
      const { data: profile, error: profileError } = await supabase
        .from("profiles")
        .select("username")
        .eq("id", $user.id)
        .single();
      if (profileError) throw profileError;
      currentUserUsername = profile.username || "Unknown";
      console.log("Fetched username:", currentUserUsername);
    } catch (err) {
      console.error("Error fetching username:", err);
      currentUserUsername = "Unknown";
    }
  });

  async function fetchTasks() {
    if (!selectedChallenge) {
      tasks = [];
      selectedTask = null;
      submissionData.verification = "";
      attachments = [];
      loadingTasks = false;
      return;
    }

    loadingTasks = true;
    try {
      const { data, error: fetchError } = await supabase
        .from("tasks")
        .select("id, action, verification_type, require_attachment") // Updated to match DB column
        .eq("challenge_id", selectedChallenge.id);
      if (fetchError) throw fetchError;
      tasks = data || [];
      console.log(
        "Fetched tasks for challenge",
        selectedChallenge.id,
        ":",
        tasks
      );
      selectedTask = null;
      submissionData.verification = "";
      attachments = [];
    } catch (err) {
      console.error("Error fetching tasks:", err);
      error = "Failed to load tasks for this challenge.";
      tasks = [];
    } finally {
      loadingTasks = false;
    }
  }

  $: if (selectedChallenge !== null) {
    fetchTasks();
  }

  $: if (selectedTask && selectedTask !== prevSelectedTask) {
    console.log("Selected task changed:", selectedTask);
    submissionData.verification = "";
    attachments = [];
    console.log(
      "Form should render for verification_type:",
      selectedTask.verification_type
    );
    prevSelectedTask = selectedTask;
  }

  function handleAttachmentUpload(event) {
    attachments = Array.from(event.target.files);
    console.log("Attachments updated:", attachments);
  }

  function formatTimeInput(event) {
    let value = event.target.value.replace(/[^0-9]/g, "");
    if (value.length > 6) value = value.slice(0, 6);

    let formatted = "";
    if (value.length > 4) {
      formatted = `${value.slice(0, 2)}:${value.slice(2, 4)}:${value.slice(4, 6)}`;
    } else if (value.length > 2) {
      formatted = `${value.slice(0, 2)}:${value.slice(2)}`;
    } else {
      formatted = value;
    }
    submissionData.verification = formatted;
    console.log("Time input updated:", submissionData.verification);
  }

  async function submitTaskCompletion() {
    if (!selectedTask) {
      alert("Please select a task.");
      return;
    }

    if (
      selectedTask.verification_type !== "none" &&
      !submissionData.verification
    ) {
      alert("Please provide the required verification input.");
      return;
    }
    if (selectedTask.require_attachment && attachments.length === 0) {
      // Updated to match DB column
      alert("Please upload at least one attachment.");
      return;
    }

    if (selectedTask.verification_type === "Time Entry") {
      const timePattern = /^[0-2][0-3]:[0-5][0-9]:[0-5][0-9]$/;
      if (!timePattern.test(submissionData.verification)) {
        alert("Please enter time in HH:MM:SS format (e.g., 01:23:45).");
        return;
      }
    }

    let attachmentUrls = [];
    if (attachments.length > 0) {
      try {
        attachmentUrls = await Promise.all(
          attachments.map(async (file) => {
            const fileName = `${Date.now()}-${file.name}`;
            const { error } = await supabase.storage
              .from("media")
              .upload(fileName, file);
            if (error) throw error;
            return supabase.storage.from("media").getPublicUrl(fileName).data
              .publicUrl;
          })
        );
        console.log("Uploaded attachments:", attachmentUrls);
      } catch (err) {
        console.error("Error uploading attachments:", err);
        alert("Failed to upload attachments.");
        return;
      }
    }

    const submittedData = {
      verification: {
        type: selectedTask.verification_type,
        value: submissionData.verification || null,
      },
      attachments: attachmentUrls,
    };

    try {
      const { error: completionError } = await supabase
        .from("task_completions")
        .insert([
          {
            task_id: selectedTask.id,
            user_id: $user.id,
            challenge_id: selectedChallenge.id,
            submitted_data: submittedData,
            status: "pending",
          },
        ]);
      if (completionError) throw completionError;

      let postContent = `${currentUserUsername} completed task: ${selectedTask.action}`;
      if (
        selectedTask.verification_type !== "none" &&
        submissionData.verification
      ) {
        postContent += ` with ${selectedTask.verification_type}: ${submissionData.verification}`;
      }
      if (attachmentUrls.length > 0) {
        postContent += ` and attached files.`;
      }

      const { error: postError } = await supabase.from("posts").insert([
        {
          challenge_id: selectedChallenge.id,
          content: postContent,
          user_id: $user.id,
          username: currentUserUsername,
          media_urls: attachmentUrls,
          parent_id: null,
          created_at: new Date().toISOString(),
        },
      ]);
      if (postError) throw postError;

      showTaskCompletionForm.set(false);
      selectedChallenge = null;
      selectedTask = null;
      submissionData.verification = "";
      attachments = [];
      onClose();
    } catch (err) {
      console.error("Error submitting task:", err);
      alert("Failed to submit task. Please try again.");
    }
  }
</script>

<div
  class="modal"
  on:click|stopPropagation
  on:keydown={(e) => e.key === "Escape" && onClose()}
  role="dialog"
  tabindex="0"
>
  <h2>Submit Task Completion</h2>

  {#if loadingChallenges}
    <p>Loading challenges...</p>
  {:else if error}
    <p class="error">{error}</p>
  {:else}
    <label>
      Select Challenge:
      <select bind:value={selectedChallenge}>
        <option value={null}>Choose a challenge</option>
        {#each challenges as challenge}
          <option value={challenge}>{challenge.title}</option>
        {/each}
      </select>
    </label>

    {#if selectedChallenge}
      {#if loadingTasks}
        <p>Loading tasks...</p>
      {:else}
        <label>
          Select Task:
          <select bind:value={selectedTask}>
            <option value={null}>Choose a task</option>
            {#each tasks as task}
              <option value={task}>{task.action}</option>
            {/each}
          </select>
        </label>
      {/if}
    {/if}

    {#if selectedTask}
      <div class="submission-form">
        {#if selectedTask.verification_type === "Text Form"}
          <label>
            Text Form:
            <textarea
              bind:value={submissionData.verification}
              required={selectedTask.verification_type !== "none"}
              placeholder="Enter your description"
            ></textarea>
          </label>
        {:else if selectedTask.verification_type === "Time Entry"}
          <label>
            Time Entry (HH:MM:SS):
            <input
              type="text"
              bind:value={submissionData.verification}
              on:input={formatTimeInput}
              required={selectedTask.verification_type !== "none"}
              placeholder="HH:MM:SS (e.g., 01:23:45)"
              pattern="[0-2][0-3]:[0-5][0-9]:[0-5][0-9]"
              title="Enter time in HH:MM:SS format (00:00:00 to 23:59:59)"
            />
          </label>
        {:else if selectedTask.verification_type === "Numerical Entry"}
          <label>
            Numerical Entry (##.##):
            <input
              type="number"
              step="0.01"
              bind:value={submissionData.verification}
              required={selectedTask.verification_type !== "none"}
            />
          </label>
        {/if}
        {#if selectedTask.require_attachment}
          <!-- Updated to match DB column -->
          <label>
            Attachments (at least one required):
            <input
              type="file"
              multiple
              accept="image/*,video/*,.pdf"
              on:change={handleAttachmentUpload}
              required={selectedTask.require_attachment}
            />
          </label>
        {/if}
      </div>
    {/if}

    <div class="actions">
      <button on:click={submitTaskCompletion} disabled={!selectedTask}
        >Submit</button
      >
      <button
        on:click={() => {
          showTaskCompletionForm.set(false);
          onClose();
        }}>Cancel</button
      >
    </div>
  {/if}
</div>

<style>
  .modal {
    padding: 20px;
    background: #fff;
    border-radius: 8px;
    max-width: 500px;
    width: 90%;
    max-height: 80vh;
    overflow-y: auto;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  }
  label {
    display: block;
    margin: 10px 0;
  }
  select,
  input,
  textarea {
    width: 100%;
    padding: 8px;
    border: 1px solid var(--light-gray);
    border-radius: 4px;
  }
  .submission-form {
    margin-top: 15px;
  }
  .actions {
    margin-top: 20px;
    display: flex;
    gap: 10px;
  }
  button {
    padding: 10px 20px;
    background-color: var(--tomato);
    color: var(--white);
    border: none;
    border-radius: 4px;
    cursor: pointer;
  }
  button:disabled {
    background-color: var(--light-gray);
    cursor: not-allowed;
  }
  button:hover:not(:disabled) {
    background-color: var(--tomato-light);
  }
  .error {
    color: var(--tomato);
    font-weight: bold;
  }
</style>
