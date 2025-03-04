<script>
  import { onMount, createEventDispatcher } from "svelte";
  import { supabase } from "../supabase.js";
  import { user, showTaskCompletionForm } from "../stores.js";

  export let preSelectedChallengeId = null;
  export let preSelectedTaskId = null;

  const dispatch = createEventDispatcher();

  let challenges = [];
  let selectedChallenge = null;
  let tasks = [];
  let selectedTask = null;
  let submissionData = { verification: "", comment: "" };
  let attachments = [];
  let currentUserFirstName = "";
  let currentUserLastName = "";
  let loadingChallenges = true;
  let loadingTasks = false;
  let error = null;
  let prevSelectedTask = null;
  let modalElement;
  let videoWatched = false;

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

      if (preSelectedChallengeId) {
        selectedChallenge =
          challenges.find((c) => c.id === preSelectedChallengeId) || null;
        if (selectedChallenge && preSelectedTaskId) {
          await fetchTasks();
          selectedTask = tasks.find((t) => t.id === preSelectedTaskId) || null;
        }
      }
    } catch (err) {
      console.error("Error fetching challenges:", err);
      error = "Failed to load challenges. Please try again.";
    } finally {
      loadingChallenges = false;
    }

    try {
      const { data: profile, error: profileError } = await supabase
        .from("profiles")
        .select("first_name, last_name")
        .eq("id", $user.id)
        .single();
      if (profileError) throw profileError;
      currentUserFirstName = profile.first_name || "Anonymous";
      currentUserLastName = profile.last_name || "";
      console.log("Fetched user profile:", {
        currentUserFirstName,
        currentUserLastName,
      });
    } catch (err) {
      console.error("Error fetching user profile:", err);
      currentUserFirstName = "Anonymous";
      currentUserLastName = "";
    }

    if (modalElement)
      modalElement.querySelector("button, input, select")?.focus();
  });

  async function fetchTasks() {
    if (!selectedChallenge) {
      tasks = [];
      selectedTask = null;
      submissionData.verification = "";
      submissionData.comment = "";
      attachments = [];
      loadingTasks = false;
      return;
    }

    loadingTasks = true;
    try {
      const { data, error: fetchError } = await supabase
        .from("tasks")
        .select(
          "id, action, verification_type, require_attachment, media_url, require_video_completion"
        )
        .eq("challenge_id", selectedChallenge.id);
      if (fetchError) throw fetchError;
      tasks = data || [];
      if (preSelectedTaskId) {
        selectedTask = tasks.find((t) => t.id === preSelectedTaskId) || null;
      } else {
        selectedTask = null;
      }
      submissionData.verification = "";
      submissionData.comment = "";
      attachments = [];
      videoWatched = false;
    } catch (err) {
      console.error("Error fetching tasks:", err);
      error = "Failed to load tasks for this challenge.";
      tasks = [];
    } finally {
      loadingTasks = false;
    }
  }

  $: if (selectedChallenge !== null && !preSelectedTaskId) fetchTasks();

  $: if (selectedTask && selectedTask !== prevSelectedTask) {
    submissionData.verification = "";
    submissionData.comment = "";
    attachments = [];
    videoWatched = false;
    prevSelectedTask = selectedTask;
  }

  function handleAttachmentUpload(event) {
    attachments = Array.from(event.target.files);
  }

  function formatTimeInput(event) {
    let value = event.target.value.replace(/[^0-9]/g, "");
    if (value.length > 6) value = value.slice(0, 6);
    let formatted = "";
    if (value.length > 4)
      formatted = `${value.slice(0, 2)}:${value.slice(2, 4)}:${value.slice(4, 6)}`;
    else if (value.length > 2)
      formatted = `${value.slice(0, 2)}:${value.slice(2)}`;
    else formatted = value;
    submissionData.verification = formatted;
  }

  function handleVideoEnd() {
    videoWatched = true;
    console.log("Video fully watched:", videoWatched);
  }

  async function submitTaskCompletion() {
    if (!selectedTask) {
      alert("Please select a task.");
      return;
    }

    if (
      selectedTask.verification_type !== "No Verification" &&
      !submissionData.verification
    ) {
      alert("Please provide the required verification input.");
      return;
    }
    if (selectedTask.require_attachment && attachments.length === 0) {
      alert("Please upload at least one attachment.");
      return;
    }
    if (!submissionData.comment.trim()) {
      alert("Please enter a comment for your submission.");
      return;
    }
    if (
      selectedTask.require_video_completion &&
      selectedTask.media_url &&
      !videoWatched
    ) {
      alert("Please watch the full video before submitting.");
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
            const { data, error } = await supabase.storage
              .from("media")
              .upload(fileName, file, { upsert: true });
            if (error) throw error;
            return supabase.storage.from("media").getPublicUrl(fileName).data
              .publicUrl;
          })
        );
        console.log("Uploaded attachments:", attachmentUrls);
      } catch (err) {
        console.error("Error uploading attachments:", err);
        alert(
          "Failed to upload attachments: " + (err.message || "Unknown error")
        );
        return;
      }
    }

    const submittedData = {
      verification: {
        type: selectedTask.verification_type,
        value:
          selectedTask.verification_type === "No Verification"
            ? null
            : submissionData.verification,
      },
      attachments: attachmentUrls,
      video_watched: selectedTask.require_video_completion
        ? videoWatched
        : null,
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

      const postContent = submissionData.comment;
      console.log(
        "Inserting post with content:",
        postContent,
        "and media_urls:",
        attachmentUrls
      );
      const { data: postData, error: postError } = await supabase
        .from("posts")
        .insert([
          {
            challenge_id: selectedChallenge.id,
            content: postContent,
            user_id: $user.id,
            media_urls: attachmentUrls.length > 0 ? attachmentUrls : [],
            parent_id: null,
            created_at: new Date().toISOString(),
          },
        ])
        .select();
      if (postError) {
        console.error("Post insertion error:", postError);
        throw postError;
      }
      console.log("Post inserted successfully:", postData);

      showTaskCompletionForm.set(false);
      selectedChallenge = null;
      selectedTask = null;
      submissionData.verification = "";
      submissionData.comment = "";
      attachments = [];
      videoWatched = false;
      dispatch("close");
    } catch (err) {
      console.error("Error submitting task:", err);
      alert("Failed to submit task: " + (err.message || "Unknown error"));
    }
  }

  function handleKeydown(e) {
    if (e.key === "Escape") dispatch("close");
    if (e.key === "Tab") {
      const focusable = modalElement.querySelectorAll(
        'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
      );
      const first = focusable[0];
      const last = focusable[focusable.length - 1];
      if (e.shiftKey && document.activeElement === first) {
        e.preventDefault();
        last.focus();
      } else if (!e.shiftKey && document.activeElement === last) {
        e.preventDefault();
        first.focus();
      }
    }
  }
</script>

<div
  class="modal"
  bind:this={modalElement}
  on:click|stopPropagation
  on:keydown={handleKeydown}
  role="dialog"
  aria-labelledby="modal-title"
  aria-modal="true"
>
  <h2 id="modal-title">Submit Task Completion</h2>

  {#if loadingChallenges}
    <p>Loading challenges...</p>
  {:else if error}
    <p class="error">{error}</p>
  {:else}
    <label>
      Select Challenge:
      <select
        bind:value={selectedChallenge}
        disabled={!!preSelectedChallengeId}
      >
        <option value={null}>Choose a challenge</option>
        {#each challenges as challenge}
          <option
            value={challenge}
            selected={challenge.id === preSelectedChallengeId}
          >
            {challenge.title}
          </option>
        {/each}
      </select>
    </label>

    {#if selectedChallenge}
      {#if loadingTasks}
        <p>Loading tasks...</p>
      {:else}
        <label>
          Select Task:
          <select bind:value={selectedTask} disabled={!!preSelectedTaskId}>
            <option value={null}>Choose a task</option>
            {#each tasks as task}
              <option value={task} selected={task.id === preSelectedTaskId}>
                {task.action}
              </option>
            {/each}
          </select>
        </label>
      {/if}
    {/if}

    {#if selectedTask}
      <div class="submission-form">
        {#if selectedTask.media_url}
          {#if selectedTask.media_url.match(/\.(mp4|webm|ogg)$/i)}
            <div>
              <p>Watch the video below:</p>
              <video
                controls
                src={selectedTask.media_url}
                on:ended={handleVideoEnd}
                width="100%"
              >
                <track
                  kind="captions"
                  label="Video Captions"
                  src=""
                  srclang="en"
                  default
                />
                Your browser does not support the video tag.
              </video>
              {#if selectedTask.require_video_completion}
                <p class="note">
                  You must watch the full video to submit this task.
                </p>
              {/if}
            </div>
          {:else}
            <div>
              <p>Task Image:</p>
              <img src={selectedTask.media_url} alt="Task media" width="100%" />
            </div>
          {/if}
        {/if}
        {#if selectedTask.verification_type === "Text Form"}
          <label>
            Text Form (required):
            <textarea
              bind:value={submissionData.verification}
              required
              placeholder="Enter your description"
            ></textarea>
          </label>
        {:else if selectedTask.verification_type === "Time Entry"}
          <label>
            Time Entry (HH:MM:SS, required):
            <input
              type="text"
              bind:value={submissionData.verification}
              on:input={formatTimeInput}
              required
              placeholder="HH:MM:SS (e.g., 01:23:45)"
              pattern="[0-2][0-3]:[0-5][0-9]:[0-5][0-9]"
              title="Enter time in HH:MM:SS format (00:00:00 to 23:59:59)"
            />
          </label>
        {:else if selectedTask.verification_type === "Numerical Entry"}
          <label>
            Numerical Entry (##.##, required):
            <input
              type="number"
              step="0.01"
              bind:value={submissionData.verification}
              required
            />
          </label>
        {/if}
        {#if selectedTask.require_attachment}
          <label>
            Attachments (at least one required):
            <input
              type="file"
              multiple
              accept="image/*,video/*,.pdf"
              on:change={handleAttachmentUpload}
              required
            />
          </label>
        {/if}
        <label>
          Comment (required):
          <textarea
            bind:value={submissionData.comment}
            required
            placeholder="Enter your submission message"
          ></textarea>
        </label>
      </div>
    {/if}

    <div class="actions">
      <button on:click={submitTaskCompletion} disabled={!selectedTask}
        >Submit</button
      >
      <button on:click={() => dispatch("close")}>Cancel</button>
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
    outline: none;
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
  .note {
    color: var(--charcoal);
    font-size: 0.9rem;
    margin-top: 5px;
  }
</style>
