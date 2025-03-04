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
  let mediaFile = null; // New: For photo/video upload
  let mediaUrl = ""; // New: Store uploaded media URL
  let requireVideoCompletion = false; // New: Checkbox for video completion
  let isVideo = false; // New: Detect if uploaded file is a video
  let errorMessage = "";

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
      mediaUrl = task.media_url || ""; // Load existing media URL if any
      requireVideoCompletion = task.require_video_completion || false;
      isVideo = mediaUrl && mediaUrl.match(/\.(mp4|webm|ogg)$/i); // Check if existing media is video
    }
  });

  // Handle file upload and detect if it's a video
  function handleMediaUpload(event) {
    mediaFile = event.target.files[0];
    if (mediaFile) {
      isVideo = mediaFile.type.startsWith("video/");
      console.log("Media uploaded:", mediaFile, "Is video:", isVideo);
    } else {
      isVideo = false;
      requireVideoCompletion = false;
    }
  }

  async function saveTask(event) {
    event.preventDefault();
    console.log("saveTask called");

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

    // Upload media if provided
    let uploadedMediaUrl = mediaUrl;
    if (mediaFile) {
      const fileName = `${Date.now()}-${mediaFile.name}`;
      const { data, error } = await supabase.storage
        .from("media")
        .upload(fileName, mediaFile, { upsert: true });
      if (error) {
        errorMessage = "Failed to upload media: " + error.message;
        console.error("Media upload error:", error);
        return false;
      }
      uploadedMediaUrl = supabase.storage.from("media").getPublicUrl(fileName)
        .data.publicUrl;
      console.log("Media uploaded:", uploadedMediaUrl);
    }

    const taskData = {
      challenge_id: challengeId,
      action,
      frequency: finalFrequency,
      verification_type: verificationType,
      notes,
      require_attachment: requireAttachment,
      media_url: uploadedMediaUrl || null, // New: Save media URL
      require_video_completion: isVideo ? requireVideoCompletion : false, // New: Save video completion requirement
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
      console.error("Supabase error:", error);
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
    mediaFile = null;
    mediaUrl = "";
    requireVideoCompletion = false;
    isVideo = false;
    errorMessage = "";
  }

  async function closeAndSave() {
    const success = await saveTask({ preventDefault: () => {} });
    if (success) dispatch("close");
  }

  function close() {
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
    <!-- New: Media Upload -->
    <label>
      Upload Photo/Video (optional):
      <input
        type="file"
        accept="image/*,video/*"
        on:change={handleMediaUpload}
      />
      {#if mediaUrl}
        <p>Current media: <a href={mediaUrl} target="_blank">View</a></p>
      {/if}
    </label>
    {#if isVideo}
      <label>
        Require Participants to Watch Full Video:
        <div class="toggle-switch">
          <input
            type="checkbox"
            id="requireVideoCompletion"
            bind:checked={requireVideoCompletion}
          />
          <label for="requireVideoCompletion" class="slider"></label>
        </div>
      </label>
    {/if}
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
  /* Existing styles unchanged */
  /* Add any additional styling if needed */
</style>
