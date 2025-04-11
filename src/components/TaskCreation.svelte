<script>
  import { createEventDispatcher, onMount } from "svelte";
  import { supabase } from "../supabase.js";
  import LoadingSpinner from "./LoadingSpinner.svelte";

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
  let mediaFile = null;
  let mediaUrl = "";
  let requireVideoCompletion = false;
  let isVideo = false;
  let errorMessage = "";
  let submitting = false;
  let mediaPreview = null;
  let fileInputRef;

  onMount(() => {
    console.log("TaskCreation mounted. editMode:", editMode, "task:", task);
    if (editMode && task) {
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
      mediaUrl = task.media_url || "";
      requireVideoCompletion = task.require_video_completion || false;
      isVideo = mediaUrl && mediaUrl.match(/\.(mp4|webm|ogg)$/i);

      if (mediaUrl) {
        updateMediaPreview(mediaUrl);
      }
    }
  });

  // Handle file upload and detect if it's a video
  function handleMediaUpload(event) {
    const file = event.target.files[0];
    if (!file) return;

    mediaFile = file;
    isVideo = file.type.startsWith("video/");

    // Create preview
    const fileUrl = URL.createObjectURL(file);
    updateMediaPreview(fileUrl, true);

    console.log("Media uploaded:", mediaFile, "Is video:", isVideo);
  }

  function updateMediaPreview(url, isObjectUrl = false) {
    // Clear any existing preview
    if (mediaPreview && mediaPreview.isObjectUrl) {
      URL.revokeObjectURL(mediaPreview.url);
    }

    if (!url) {
      mediaPreview = null;
      return;
    }

    const isVideoFile = url.match(/\.(mp4|webm|ogg)$/i);
    mediaPreview = {
      url,
      isObjectUrl,
      type: isVideoFile ? "video" : "image",
    };
  }

  function removeMedia() {
    if (mediaFile) {
      mediaFile = null;
    }

    if (mediaPreview && mediaPreview.isObjectUrl) {
      URL.revokeObjectURL(mediaPreview.url);
    }

    mediaPreview = null;
    isVideo = false;
    requireVideoCompletion = false;

    if (editMode && mediaUrl) {
      mediaUrl = "";
    }
  }

  async function saveTask(event) {
    if (event && event.preventDefault) {
      event.preventDefault();
    }

    if (submitting) return false;

    if (!action || !frequency || !verificationType) {
      errorMessage = "Please fill in all required fields.";
      return false;
    }

    let finalFrequency = frequency;
    if (frequency === "Custom") {
      if (!customValue || isNaN(customValue) || customValue <= 0) {
        errorMessage = "Please enter a valid number for custom frequency.";
        return false;
      }
      finalFrequency = `Every ${customValue} ${customUnit}`;
    }

    submitting = true;

    // Upload media if provided
    let uploadedMediaUrl = mediaUrl;
    if (mediaFile) {
      try {
        const fileName = `${Date.now()}-${mediaFile.name}`;
        const { data, error } = await supabase.storage
          .from("media")
          .upload(fileName, mediaFile, { upsert: true });
        if (error) {
          errorMessage = "Failed to upload media: " + error.message;
          console.error("Media upload error:", error);
          submitting = false;
          return false;
        }
        uploadedMediaUrl = supabase.storage.from("media").getPublicUrl(fileName)
          .data.publicUrl;
        console.log("Media uploaded:", uploadedMediaUrl);
      } catch (err) {
        errorMessage = "Failed to upload media: " + err.message;
        console.error("Media upload error:", err);
        submitting = false;
        return false;
      }
    }

    const taskData = {
      challenge_id: challengeId,
      action,
      frequency: finalFrequency,
      verification_type: verificationType,
      notes,
      require_attachment: requireAttachment,
      media_url: uploadedMediaUrl || null,
      require_video_completion: isVideo ? requireVideoCompletion : false,
    };

    console.log("Saving task to Supabase:", taskData);
    try {
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
        console.error("Supabase error:", error);
        submitting = false;
        return false;
      }

      console.log("Task saved successfully:", data);
      dispatch("taskCreated", data);
      resetForm();

      // Clean up any object URLs
      if (mediaPreview && mediaPreview.isObjectUrl) {
        URL.revokeObjectURL(mediaPreview.url);
      }

      submitting = false;
      return true;
    } catch (err) {
      errorMessage = err.message;
      console.error("Error saving task:", err);
      submitting = false;
      return false;
    }
  }

  function resetForm() {
    action = "";
    frequency = "";
    customValue = "";
    customUnit = "days";
    verificationType = "";
    notes = "";
    requireAttachment = false;
    mediaFile = null;
    mediaUrl = "";
    requireVideoCompletion = false;
    isVideo = false;
    errorMessage = "";

    if (mediaPreview && mediaPreview.isObjectUrl) {
      URL.revokeObjectURL(mediaPreview.url);
    }
    mediaPreview = null;
  }

  async function closeAndSave() {
    const success = await saveTask();
    if (success) dispatch("close");
  }

  function close() {
    // Clean up any object URLs
    if (mediaPreview && mediaPreview.isObjectUrl) {
      URL.revokeObjectURL(mediaPreview.url);
    }

    dispatch("close");
  }
</script>

<div class="task-creation-modal">
  <div class="modal-header">
    <h2>{editMode ? "Edit Task" : "Create Task"}</h2>
    <button class="close-button" on:click={close} aria-label="Close">×</button>
  </div>

  {#if errorMessage}
    <div class="error-message">
      <p>{errorMessage}</p>
    </div>
  {/if}

  <div class="modal-content">
    <form on:submit|preventDefault={saveTask}>
      <div class="form-group">
        <label for="action" class="form-label">Task Description:</label>
        <input
          type="text"
          id="action"
          bind:value={action}
          class="form-input"
          placeholder="What should participants do?"
          required
        />
      </div>

      <div class="form-group">
        <label for="frequency" class="form-label">Frequency:</label>
        <select
          id="frequency"
          bind:value={frequency}
          class="form-select"
          required
        >
          <option value="">Select Frequency</option>
          <option value="per hour">Per Hour</option>
          <option value="per day">Per Day</option>
          <option value="per week">Per Week</option>
          <option value="per month">Per Month</option>
          <option value="per challenge">Per Challenge</option>
          <option value="Custom">Custom</option>
        </select>
      </div>

      {#if frequency === "Custom"}
        <div class="form-group custom-frequency">
          <div class="frequency-inputs">
            <div class="custom-value-input">
              <label for="customValue" class="form-label">Every:</label>
              <input
                type="number"
                id="customValue"
                bind:value={customValue}
                min="1"
                class="form-input"
                required
                placeholder="e.g., 5"
              />
            </div>

            <div class="custom-unit-input">
              <label for="customUnit" class="form-label">Unit:</label>
              <select
                id="customUnit"
                bind:value={customUnit}
                class="form-select"
                required
              >
                <option value="minutes">Minutes</option>
                <option value="hours">Hours</option>
                <option value="days">Days</option>
                <option value="weeks">Weeks</option>
                <option value="months">Months</option>
              </select>
            </div>
          </div>
        </div>
      {/if}

      <div class="form-group">
        <label for="verification" class="form-label">Verification Method:</label
        >
        <select
          id="verification"
          bind:value={verificationType}
          class="form-select"
          required
        >
          <option value="">Select Verification Type</option>
          <option value="Text Form">Text Form</option>
          <option value="Time Entry">Time Entry</option>
          <option value="Numerical Entry">Numerical Entry</option>
          <option value="No Verification">No Verification</option>
        </select>
      </div>

      <div class="form-group">
        <div class="toggle-container">
          <label for="requireAttachment" class="form-label">
            Require Attachment Upload:
          </label>
          <label class="toggle-switch">
            <input
              type="checkbox"
              id="requireAttachment"
              bind:checked={requireAttachment}
            />
            <span class="toggle-slider"></span>
          </label>
        </div>
      </div>

      <div class="form-group">
        <label for="media-upload" class="form-label"
          >Upload Media (optional):</label
        >
        <div class="media-upload-container">
          <button
            type="button"
            class="media-upload-button"
            on:click={() => fileInputRef.click()}
          >
            {mediaFile || mediaUrl ? "Change Media" : "Upload Photo/Video"}
          </button>
          <input
            id="media-upload"
            type="file"
            accept="image/*,video/*"
            on:change={handleMediaUpload}
            bind:this={fileInputRef}
            class="hidden-file-input"
          />
        </div>

        {#if mediaPreview}
          <div class="media-preview">
            {#if mediaPreview.type === "image"}
              <img
                src={mediaPreview.url}
                alt="Media preview"
                class="preview-image"
              />
            {:else if mediaPreview.type === "video"}
              <video src={mediaPreview.url} controls class="preview-video">
                <track kind="captions" label="No captions available" />
              </video>
            {/if}
            <button
              type="button"
              class="remove-media-button"
              on:click={removeMedia}
            >
              Remove
            </button>
          </div>
        {:else if mediaUrl && !mediaPreview}
          <div class="media-link">
            <span>Current media: </span>
            <a href={mediaUrl} target="_blank" rel="noopener noreferrer">View</a
            >
          </div>
        {/if}
      </div>

      {#if isVideo}
        <div class="form-group">
          <div class="toggle-container">
            <label for="requireVideoCompletion" class="form-label">
              Require Participants to Watch Full Video:
            </label>
            <label class="toggle-switch">
              <input
                type="checkbox"
                id="requireVideoCompletion"
                bind:checked={requireVideoCompletion}
              />
              <span class="toggle-slider"></span>
            </label>
          </div>
        </div>
      {/if}

      <div class="form-group">
        <label for="notes" class="form-label">Additional Notes:</label>
        <textarea
          id="notes"
          bind:value={notes}
          class="form-textarea"
          placeholder="Any additional instructions or context"
          rows="3"
        ></textarea>
      </div>
    </form>
  </div>

  <div class="modal-footer">
    <button
      type="button"
      class="save-button"
      on:click={saveTask}
      disabled={submitting}
    >
      {#if submitting}
        <span class="spinner-icon">↻</span> Saving...
      {:else}
        {editMode ? "Update Task" : "Add Task"}
      {/if}
    </button>

    {#if editMode}
      <button
        type="button"
        class="complete-button"
        on:click={closeAndSave}
        disabled={submitting}
      >
        Done
      </button>
    {/if}

    <button type="button" class="cancel-button" on:click={close}>
      Cancel
    </button>
  </div>
</div>

<style>
  .task-creation-modal {
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

  .error-message {
    background-color: rgba(244, 67, 54, 0.1);
    color: var(--error);
    padding: 8px 16px;
    border-radius: 4px;
    margin: 0 16px;
    font-size: 14px;
  }

  .modal-content {
    padding: 16px;
    flex: 1;
    overflow-y: auto;
  }

  form {
    display: flex;
    flex-direction: column;
    gap: 16px;
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

  /* Toggle Switch */
  .toggle-container {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .toggle-switch {
    position: relative;
    display: inline-block;
    width: 50px;
    height: 24px;
  }

  .toggle-switch input {
    opacity: 0;
    width: 0;
    height: 0;
  }

  .toggle-slider {
    position: absolute;
    cursor: pointer;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: var(--light-gray);
    border-radius: 24px;
    transition: 0.4s;
  }

  .toggle-slider:before {
    position: absolute;
    content: "";
    height: 20px;
    width: 20px;
    left: 2px;
    bottom: 2px;
    background-color: white;
    border-radius: 50%;
    transition: 0.4s;
  }

  input:checked + .toggle-slider {
    background-color: var(--tomato);
  }

  input:checked + .toggle-slider:before {
    transform: translateX(26px);
  }

  /* Custom frequency inputs */
  .custom-frequency {
    background-color: var(--background);
    padding: 12px;
    border-radius: 8px;
    margin-top: 8px;
  }

  .frequency-inputs {
    display: flex;
    gap: 12px;
  }

  .custom-value-input,
  .custom-unit-input {
    flex: 1;
  }

  /* Media upload styles */
  .media-upload-container {
    margin-bottom: 12px;
  }

  .media-upload-button {
    padding: 8px 16px;
    background-color: var(--carolina-blue);
    color: white;
    border: none;
    border-radius: 8px;
    font-size: 14px;
    cursor: pointer;
  }

  .hidden-file-input {
    display: none;
  }

  .media-preview {
    margin-top: 12px;
    position: relative;
    max-width: 100%;
  }

  .preview-image,
  .preview-video {
    max-width: 100%;
    border-radius: 8px;
    border: 1px solid var(--light-gray);
  }

  .remove-media-button {
    position: absolute;
    top: 8px;
    right: 8px;
    background-color: rgba(0, 0, 0, 0.6);
    color: white;
    border: none;
    border-radius: 4px;
    padding: 4px 8px;
    font-size: 12px;
    cursor: pointer;
  }

  .media-link {
    font-size: 14px;
    margin-top: 8px;
  }

  .media-link a {
    color: var(--tomato);
    text-decoration: none;
  }

  /* Modal footer */
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

  .save-button,
  .complete-button,
  .cancel-button {
    padding: 10px 16px;
    border: none;
    border-radius: 8px;
    font-weight: 500;
    cursor: pointer;
    font-size: 14px;
  }

  .save-button {
    background-color: var(--tomato);
    color: white;
    display: flex;
    align-items: center;
    gap: 8px;
  }

  .save-button:disabled {
    background-color: var(--gray);
    cursor: not-allowed;
  }

  .complete-button {
    background-color: var(--carolina-blue);
    color: white;
  }

  .complete-button:disabled {
    background-color: var(--gray);
    cursor: not-allowed;
  }

  .cancel-button {
    background-color: var(--light-gray);
    color: var(--text);
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

  /* Responsive layout for mobile */
  @media (max-width: 480px) {
    .task-creation-modal {
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

    .frequency-inputs {
      flex-direction: column;
      gap: 8px;
    }
  }
</style>
