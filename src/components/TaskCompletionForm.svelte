<script>
  import { onMount, createEventDispatcher } from "svelte";
  import { supabase } from "../supabase.js";
  import { user, showTaskCompletionForm } from "../stores.js";
  import LoadingSpinner from "../components/LoadingSpinner.svelte";

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
  let submitting = false;
  let fileInputRef;
  let previewUrls = [];

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
      previewUrls = [];
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
      previewUrls = [];
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
    previewUrls = [];
    videoWatched = false;
    prevSelectedTask = selectedTask;
  }

  function handleAttachmentUpload(event) {
    const files = Array.from(event.target.files);
    attachments = files;

    // Create preview URLs for images
    previewUrls = [];
    files.forEach((file) => {
      if (file.type.startsWith("image/")) {
        const url = URL.createObjectURL(file);
        previewUrls.push({ file: file.name, url, type: "image" });
      } else if (file.type.startsWith("video/")) {
        const url = URL.createObjectURL(file);
        previewUrls.push({ file: file.name, url, type: "video" });
      } else {
        previewUrls.push({ file: file.name, url: null, type: "document" });
      }
    });
  }

  function removeAttachment(index) {
    // Create new arrays without the item at the specified index
    attachments = attachments.filter((_, i) => i !== index);

    // Revoke object URL to avoid memory leaks
    if (previewUrls[index].url) {
      URL.revokeObjectURL(previewUrls[index].url);
    }
    previewUrls = previewUrls.filter((_, i) => i !== index);
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

    submitting = true;

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
        submitting = false;
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
      previewUrls = [];
      videoWatched = false;

      // Clean up object URLs to prevent memory leaks
      previewUrls.forEach((preview) => {
        if (preview.url) URL.revokeObjectURL(preview.url);
      });

      dispatch("close");
    } catch (err) {
      console.error("Error submitting task:", err);
      alert("Failed to submit task: " + (err.message || "Unknown error"));
    } finally {
      submitting = false;
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

<section
  class="task-completion-modal"
  bind:this={modalElement}
  role="dialog"
  aria-labelledby="modal-title"
  aria-modal="true"
>
  <div class="modal-header">
    <h2 id="modal-title">Submit Task Completion</h2>
    <button
      class="close-button"
      on:click={() => dispatch("close")}
      aria-label="Close">×</button
    >
  </div>

  {#if loadingChallenges}
    <div class="loading-container">
      <LoadingSpinner />
      <p>Loading challenges...</p>
    </div>
  {:else if error}
    <div class="error-container">
      <p class="error">{error}</p>
      <button class="close-btn" on:click={() => dispatch("close")}>Close</button
      >
    </div>
  {:else}
    <div class="modal-content">
      <div class="form-group">
        <label for="challenge-select" class="form-label">Challenge:</label>
        <select
          id="challenge-select"
          bind:value={selectedChallenge}
          disabled={!!preSelectedChallengeId || loadingChallenges}
          class="form-select"
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
      </div>

      {#if selectedChallenge}
        {#if loadingTasks}
          <div class="loading-container">
            <LoadingSpinner size="small" />
            <p>Loading tasks...</p>
          </div>
        {:else}
          <div class="form-group">
            <label for="task-select" class="form-label">Task:</label>
            <select
              id="task-select"
              bind:value={selectedTask}
              disabled={!!preSelectedTaskId || loadingTasks}
              class="form-select"
            >
              <option value={null}>Choose a task</option>
              {#each tasks as task}
                <option value={task} selected={task.id === preSelectedTaskId}>
                  {task.action}
                </option>
              {/each}
            </select>
          </div>
        {/if}
      {/if}

      {#if selectedTask}
        <div class="task-details">
          {#if selectedTask.media_url}
            <div class="task-media">
              {#if selectedTask.media_url.match(/\.(mp4|webm|ogg)$/i)}
                <div class="video-container">
                  <video
                    controls
                    src={selectedTask.media_url}
                    on:ended={handleVideoEnd}
                    class="task-video"
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
                    <div class="video-status">
                      <div
                        class="status-indicator"
                        class:watched={videoWatched}
                      >
                        {videoWatched ? "✓" : "!"}
                      </div>
                      <p class="status-text">
                        {videoWatched
                          ? "Video watched"
                          : "You must watch the full video"}
                      </p>
                    </div>
                  {/if}
                </div>
              {:else}
                <div class="image-container">
                  <img
                    src={selectedTask.media_url}
                    alt="Task media"
                    class="task-image"
                  />
                </div>
              {/if}
            </div>
          {/if}

          {#if selectedTask.verification_type === "Text Form"}
            <div class="form-group">
              <label for="text-verification" class="form-label"
                >Verification Text:</label
              >
              <textarea
                id="text-verification"
                bind:value={submissionData.verification}
                class="form-textarea"
                required
                placeholder="Enter your description"
                rows="3"
              ></textarea>
            </div>
          {:else if selectedTask.verification_type === "Time Entry"}
            <div class="form-group">
              <label for="time-verification" class="form-label"
                >Time (HH:MM:SS):</label
              >
              <input
                type="text"
                id="time-verification"
                bind:value={submissionData.verification}
                on:input={formatTimeInput}
                class="form-input"
                required
                placeholder="HH:MM:SS (e.g., 01:23:45)"
                pattern="[0-2][0-3]:[0-5][0-9]:[0-5][0-9]"
                title="Enter time in HH:MM:SS format (00:00:00 to 23:59:59)"
              />
            </div>
          {:else if selectedTask.verification_type === "Numerical Entry"}
            <div class="form-group">
              <label for="number-verification" class="form-label">Value:</label>
              <input
                type="number"
                id="number-verification"
                step="0.01"
                bind:value={submissionData.verification}
                class="form-input"
                required
              />
            </div>
          {/if}

          {#if selectedTask.require_attachment || attachments.length > 0}
            <div class="form-group">
              <label for="attachment-upload" class="form-label">
                Attachments {selectedTask.require_attachment
                  ? "(Required)"
                  : ""}:
              </label>
              <div class="attachment-input-container">
                <button
                  type="button"
                  class="attachment-button"
                  on:click={() => fileInputRef.click()}
                >
                  <span class="attachment-icon">📎</span>
                  <span>Add Files</span>
                </button>
                <input
                  id="attachment-upload"
                  type="file"
                  multiple
                  accept="image/*,video/*,.pdf,.doc,.docx"
                  on:change={handleAttachmentUpload}
                  bind:this={fileInputRef}
                  class="hidden-file-input"
                />
              </div>

              {#if previewUrls.length > 0}
                <div class="attachment-previews">
                  {#each previewUrls as preview, index}
                    <div class="attachment-preview">
                      {#if preview.type === "image"}
                        <img
                          src={preview.url}
                          alt={preview.file}
                          class="preview-thumbnail"
                        />
                      {:else if preview.type === "video"}
                        <div class="video-thumbnail">
                          <span class="file-icon">🎥</span>
                        </div>
                      {:else}
                        <div class="document-thumbnail">
                          <span class="file-icon">📄</span>
                        </div>
                      {/if}
                      <div class="preview-info">
                        <span class="preview-filename">{preview.file}</span>
                        <button
                          type="button"
                          class="remove-attachment"
                          on:click={() => removeAttachment(index)}
                          aria-label="Remove file"
                        >
                          ×
                        </button>
                      </div>
                    </div>
                  {/each}
                </div>
              {/if}
            </div>
          {/if}

          <div class="form-group">
            <label for="comment" class="form-label">Comment:</label>
            <textarea
              id="comment"
              bind:value={submissionData.comment}
              class="form-textarea"
              required
              placeholder="Share details about your task completion"
              rows="4"
            ></textarea>
          </div>
        </div>
      {/if}
    </div>

    <div class="modal-footer">
      <button
        type="button"
        class="submit-button"
        on:click={submitTaskCompletion}
        disabled={!selectedTask || submitting}
      >
        {#if submitting}
          <span class="spinner-icon">↻</span> Submitting...
        {:else}
          Submit
        {/if}
      </button>
      <button
        type="button"
        class="cancel-button"
        on:click={() => dispatch("close")}
      >
        Cancel
      </button>
    </div>
  {/if}
</section>

<style>
  .task-completion-modal {
    background-color: white;
    border-radius: 12px;
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
    width: 90%;
    max-width: 500px;
    max-height: 90vh;
    overflow-y: auto;
    display: flex;
    flex-direction: column;
  }

  .modal-header {
    padding: 16px;
    border-bottom: 1px solid var(--light-gray);
    display: flex;
    justify-content: space-between;
    align-items: center;
    position: sticky;
    top: 0;
    background-color: white;
    z-index: 10;
    border-radius: 12px 12px 0 0;
  }

  .modal-header h2 {
    margin: 0;
    font-size: 1.25rem;
    color: var(--text);
  }

  .close-button {
    background: none;
    border: none;
    color: var(--gray);
    font-size: 1.5rem;
    line-height: 1;
    cursor: pointer;
    padding: 0;
    width: 32px;
    height: 32px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    transition: background-color 0.2s;
  }

  .close-button:hover {
    background-color: var(--light-gray);
    color: var(--text);
  }

  .modal-content {
    padding: 16px;
    flex: 1;
    overflow-y: auto;
  }

  .form-group {
    margin-bottom: 16px;
  }

  .form-label {
    display: block;
    margin-bottom: 8px;
    font-weight: 500;
    color: var(--text);
    font-size: 14px;
  }

  .form-select,
  .form-input,
  .form-textarea {
    width: 100%;
    padding: 10px 12px;
    border: 1px solid var(--border-color);
    border-radius: 8px;
    font-size: 16px;
    background-color: white;
    color: var(--text);
  }

  .form-select:focus,
  .form-input:focus,
  .form-textarea:focus {
    outline: none;
    border-color: var(--tomato);
    box-shadow: 0 0 0 2px rgba(242, 100, 64, 0.2);
  }

  .form-select:disabled,
  .form-input:disabled {
    background-color: var(--light-gray);
    cursor: not-allowed;
  }

  .task-details {
    background-color: var(--background);
    border-radius: 8px;
    padding: 16px;
    margin-top: 8px;
  }

  .task-media {
    margin-bottom: 16px;
  }

  .video-container {
    border-radius: 8px;
    overflow: hidden;
    margin-bottom: 8px;
  }

  .task-video {
    width: 100%;
    border-radius: 8px;
    background-color: #000;
  }

  .image-container {
    border-radius: 8px;
    overflow: hidden;
  }

  .task-image {
    width: 100%;
    border-radius: 8px;
  }

  .video-status {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-top: 8px;
    padding: 8px;
    background-color: rgba(0, 0, 0, 0.05);
    border-radius: 8px;
  }

  .status-indicator {
    width: 24px;
    height: 24px;
    border-radius: 50%;
    background-color: #ffc107; /* Yellow warning */
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: bold;
  }

  .status-indicator.watched {
    background-color: #4caf50; /* Green success */
  }

  .status-text {
    font-size: 14px;
    margin: 0;
    color: var(--text-secondary);
  }

  .attachment-input-container {
    margin-bottom: 8px;
  }

  .attachment-button {
    display: flex;
    align-items: center;
    gap: 6px;
    padding: 8px 12px;
    background-color: var(--light-gray);
    border: 1px dashed var(--border-color);
    border-radius: 8px;
    color: var(--text);
    font-size: 14px;
    cursor: pointer;
  }

  .attachment-button:hover {
    background-color: #e8e8e8;
  }

  .attachment-icon {
    font-size: 18px;
  }

  .hidden-file-input {
    display: none;
  }

  .attachment-previews {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
    gap: 8px;
    margin-top: 8px;
  }

  .attachment-preview {
    border-radius: 8px;
    overflow: hidden;
    border: 1px solid var(--light-gray);
    position: relative;
  }

  .preview-thumbnail {
    width: 100%;
    height: 80px;
    object-fit: cover;
    display: block;
  }

  .video-thumbnail,
  .document-thumbnail {
    width: 100%;
    height: 80px;
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: var(--light-gray);
  }

  .file-icon {
    font-size: 32px;
  }

  .preview-info {
    padding: 4px;
    font-size: 12px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    background-color: var(--light-gray);
  }

  .preview-filename {
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    max-width: 70px;
  }

  .remove-attachment {
    background: none;
    border: none;
    color: var(--gray);
    font-size: 16px;
    padding: 0;
    width: 20px;
    height: 20px;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .remove-attachment:hover {
    color: var(--error);
  }

  .loading-container,
  .error-container {
    padding: 24px;
    text-align: center;
  }

  .error {
    color: var(--error);
    margin-bottom: 16px;
  }

  .modal-footer {
    padding: 16px;
    border-top: 1px solid var(--light-gray);
    display: flex;
    justify-content: flex-end;
    gap: 12px;
    position: sticky;
    bottom: 0;
    background-color: white;
    z-index: 10;
    border-radius: 0 0 12px 12px;
  }

  .submit-button {
    padding: 10px 18px;
    background-color: var(--tomato);
    color: white;
    border: none;
    border-radius: 8px;
    font-weight: 500;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 8px;
  }

  .submit-button:disabled {
    background-color: var(--gray);
    cursor: not-allowed;
  }

  .cancel-button {
    padding: 10px 18px;
    background-color: var(--light-gray);
    color: var(--text);
    border: none;
    border-radius: 8px;
    font-weight: 500;
    cursor: pointer;
  }

  .spinner-icon {
    display: inline-block;
    animation: spin 1s linear infinite;
  }

  @keyframes spin {
    from {
      transform: rotate(0deg);
    }
    to {
      transform: rotate(360deg);
    }
  }

  @media (max-width: 480px) {
    .task-completion-modal {
      width: 100%;
      max-width: 100%;
      height: 100%;
      max-height: 100%;
      border-radius: 0;
    }

    .modal-header {
      border-radius: 0;
    }

    .modal-footer {
      border-radius: 0;
    }
  }
</style>
