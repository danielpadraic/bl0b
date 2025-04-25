<!-- Full StoryCreator.svelte with all accessibility fixes -->
<script>
  import { onMount } from "svelte";
  import { user } from "../stores.js";
  import { supabase } from "../supabase.js";
  import { navigate } from "svelte-routing";

  let mediaFile = null;
  let mediaPreview = null;
  let text = "";
  let textPosition = "center"; // center, top, bottom
  let fontColor = "#ffffff";
  let fontSize = "medium"; // small, medium, large
  let hasInteractiveElement = false;
  let interactiveType = "poll"; // poll, question, slider
  let pollOptions = ["", ""];
  let question = "";
  let sliderMin = 0;
  let sliderMax = 100;
  let sliderLabel = "";
  let isSubmitting = false;
  let error = null;

  function handleMediaSelect(event) {
    const file = event.target.files[0];
    if (!file) return;

    mediaFile = file;

    // Create a preview
    const fileReader = new FileReader();
    fileReader.onload = (e) => {
      mediaPreview = e.target.result;
    };

    if (file.type.startsWith("image/")) {
      fileReader.readAsDataURL(file);
    } else if (file.type.startsWith("video/")) {
      fileReader.readAsDataURL(file);
    } else {
      error = "Please select an image or video file.";
      mediaFile = null;
    }
  }

  function addPollOption() {
    if (pollOptions.length < 4) {
      pollOptions = [...pollOptions, ""];
    }
  }

  function removePollOption(index) {
    if (pollOptions.length > 2) {
      pollOptions = pollOptions.filter((_, i) => i !== index);
    }
  }

  async function uploadStoryMedia() {
    if (!mediaFile) return null;

    const fileExt = mediaFile.name.split(".").pop();
    const fileName = `${Date.now()}-${$user.id}.${fileExt}`;
    const filePath = `stories/${fileName}`;

    const { error: uploadError } = await supabase.storage
      .from("stories")
      .upload(filePath, mediaFile);

    if (uploadError) throw uploadError;

    const { data } = supabase.storage.from("stories").getPublicUrl(filePath);

    return data.publicUrl;
  }

  async function createStory() {
    if (!mediaFile) {
      error = "Please select an image or video for your story.";
      return;
    }

    if (hasInteractiveElement) {
      if (
        interactiveType === "poll" &&
        pollOptions.some((option) => !option.trim())
      ) {
        error = "Please fill in all poll options.";
        return;
      } else if (interactiveType === "question" && !question.trim()) {
        error = "Please enter a question.";
        return;
      } else if (
        interactiveType === "slider" &&
        (!sliderLabel.trim() || sliderMin >= sliderMax)
      ) {
        error = "Please set valid slider parameters.";
        return;
      }
    }

    isSubmitting = true;
    error = null;

    try {
      // 1. Upload media to Supabase storage
      const mediaUrl = await uploadStoryMedia();
      if (!mediaUrl) throw new Error("Failed to upload media.");

      // 2. Prepare interactive element data if applicable
      let interactiveElement = null;
      if (hasInteractiveElement) {
        if (interactiveType === "poll") {
          interactiveElement = {
            type: "poll",
            options: pollOptions.map((option) => ({
              text: option,
              votes: [],
            })),
          };
        } else if (interactiveType === "question") {
          interactiveElement = {
            type: "question",
            question: question,
            responses: [],
          };
        } else if (interactiveType === "slider") {
          interactiveElement = {
            type: "slider",
            label: sliderLabel,
            min: sliderMin,
            max: sliderMax,
            responses: [],
          };
        }
      }

      // 3. Create story record in database
      const { data, error: insertError } = await supabase
        .from("stories")
        .insert([
          {
            user_id: $user.id,
            media_url: mediaUrl,
            text_overlay: text || null,
            text_position: textPosition,
            font_color: fontColor,
            font_size: fontSize,
            interactive_element: interactiveElement,
            expires_at: new Date(
              Date.now() + 24 * 60 * 60 * 1000
            ).toISOString(),
          },
        ])
        .select()
        .single();

      if (insertError) throw insertError;

      // 4. Return to stories feed
      navigate("/");
    } catch (err) {
      console.error("Error creating story:", err);
      error = err.message;
    } finally {
      isSubmitting = false;
    }
  }
</script>

<div class="story-creator">
  <div class="creator-header">
    <h1>Create Story</h1>
    <button class="close-button" on:click={() => navigate("/")}>×</button>
  </div>

  {#if error}
    <div class="error-message" role="alert">{error}</div>
  {/if}

  <div class="creator-content">
    <div class="media-section">
      {#if mediaPreview}
        <div class="media-preview">
          {#if mediaFile.type.startsWith("image/")}
            <img src={mediaPreview} alt="Story preview" />
          {:else if mediaFile.type.startsWith("video/")}
            <video src={mediaPreview} autoplay loop muted></video>
          {/if}

          {#if text}
            <div
              class="text-overlay"
              class:top={textPosition === "top"}
              class:center={textPosition === "center"}
              class:bottom={textPosition === "bottom"}
              style="color: {fontColor}; font-size: {fontSize === 'small'
                ? '16px'
                : fontSize === 'medium'
                  ? '24px'
                  : '32px'};"
            >
              {text}
            </div>
          {/if}

          {#if hasInteractiveElement}
            <div class="interactive-preview">
              {#if interactiveType === "poll"}
                <div class="poll-preview">
                  {#each pollOptions as option}
                    <div class="poll-option">{option || "Option"}</div>
                  {/each}
                </div>
              {:else if interactiveType === "question"}
                <div class="question-preview">
                  <div class="question-text">
                    {question || "Your question here"}
                  </div>
                  <input type="text" placeholder="Answer..." disabled />
                </div>
              {:else if interactiveType === "slider"}
                <div class="slider-preview">
                  <div class="slider-label">{sliderLabel || "Rate this"}</div>
                  <input
                    type="range"
                    min={sliderMin}
                    max={sliderMax}
                    disabled
                  />
                  <div class="slider-values">
                    <span>{sliderMin}</span>
                    <span>{sliderMax}</span>
                  </div>
                </div>
              {/if}
            </div>
          {/if}
        </div>

        <button
          class="remove-media"
          on:click={() => {
            mediaFile = null;
            mediaPreview = null;
          }}
        >
          Remove
        </button>
      {:else}
        <div class="media-upload">
          <input
            type="file"
            id="story-media"
            accept="image/*,video/*"
            on:change={handleMediaSelect}
            hidden
          />
          <button
            class="upload-button"
            on:click={() => document.getElementById("story-media").click()}
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="24"
              height="24"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
              <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
              <polyline points="17 8 12 3 7 8" />
              <line x1="12" y1="3" x2="12" y2="15" />
            </svg>
            <span>Select Photo or Video</span>
          </button>
        </div>
      {/if}
    </div>

    {#if mediaPreview}
      <div class="settings-section">
        <div class="text-settings">
          <h3>Text Overlay</h3>
          <textarea
            bind:value={text}
            placeholder="Add text to your story..."
            rows="2"
            id="text-overlay-input"
            aria-label="Text overlay content"
          ></textarea>

          {#if text}
            <div class="text-controls">
              <div class="control-group">
                <label for="text-position">Position</label>
                <div
                  class="position-buttons"
                  id="text-position"
                  role="radiogroup"
                  aria-label="Text position"
                >
                  <button
                    type="button"
                    class:active={textPosition === "top"}
                    on:click={() => (textPosition = "top")}
                    aria-pressed={textPosition === "top"}
                  >
                    Top
                  </button>
                  <button
                    type="button"
                    class:active={textPosition === "center"}
                    on:click={() => (textPosition = "center")}
                    aria-pressed={textPosition === "center"}
                  >
                    Center
                  </button>
                  <button
                    type="button"
                    class:active={textPosition === "bottom"}
                    on:click={() => (textPosition = "bottom")}
                    aria-pressed={textPosition === "bottom"}
                  >
                    Bottom
                  </button>
                </div>
              </div>

              <div class="control-group">
                <label for="text-color">Color</label>
                <input type="color" id="text-color" bind:value={fontColor} />
              </div>

              <div class="control-group">
                <label for="text-size">Size</label>
                <div
                  class="size-buttons"
                  id="text-size"
                  role="radiogroup"
                  aria-label="Text size"
                >
                  <button
                    type="button"
                    class:active={fontSize === "small"}
                    on:click={() => (fontSize = "small")}
                    aria-pressed={fontSize === "small"}
                  >
                    S
                  </button>
                  <button
                    type="button"
                    class:active={fontSize === "medium"}
                    on:click={() => (fontSize = "medium")}
                    aria-pressed={fontSize === "medium"}
                  >
                    M
                  </button>
                  <button
                    type="button"
                    class:active={fontSize === "large"}
                    on:click={() => (fontSize = "large")}
                    aria-pressed={fontSize === "large"}
                  >
                    L
                  </button>
                </div>
              </div>
            </div>
          {/if}
        </div>

        <div class="interactive-settings">
          <div class="toggle-container">
            <label for="has-interactive">Add Interactive Element</label>
            <input
              type="checkbox"
              id="has-interactive"
              bind:checked={hasInteractiveElement}
            />
          </div>

          {#if hasInteractiveElement}
            <div class="interactive-type">
              <label for="interactive-type-group">Type</label>
              <div
                class="type-buttons"
                id="interactive-type-group"
                role="radiogroup"
                aria-label="Interactive element type"
              >
                <button
                  type="button"
                  class:active={interactiveType === "poll"}
                  on:click={() => (interactiveType = "poll")}
                  aria-pressed={interactiveType === "poll"}
                >
                  Poll
                </button>
                <button
                  type="button"
                  class:active={interactiveType === "question"}
                  on:click={() => (interactiveType = "question")}
                  aria-pressed={interactiveType === "question"}
                >
                  Question
                </button>
                <button
                  type="button"
                  class:active={interactiveType === "slider"}
                  on:click={() => (interactiveType = "slider")}
                  aria-pressed={interactiveType === "slider"}
                >
                  Slider
                </button>
              </div>
            </div>

            {#if interactiveType === "poll"}
              <div class="poll-options">
                <label id="poll-options-label">Poll Options</label>
                <div aria-labelledby="poll-options-label">
                  {#each pollOptions as option, i}
                    <div class="poll-option-input">
                      <input
                        type="text"
                        bind:value={pollOptions[i]}
                        placeholder={`Option ${i + 1}`}
                        aria-label={`Poll option ${i + 1}`}
                      />
                      {#if i > 1}
                        <button
                          type="button"
                          class="remove-option"
                          on:click={() => removePollOption(i)}
                          aria-label={`Remove option ${i + 1}`}
                        >
                          ×
                        </button>
                      {/if}
                    </div>
                  {/each}

                  {#if pollOptions.length < 4}
                    <button
                      type="button"
                      class="add-option"
                      on:click={addPollOption}
                      aria-label="Add poll option"
                    >
                      + Add Option
                    </button>
                  {/if}
                </div>
              </div>
            {:else if interactiveType === "question"}
              <div class="question-input">
                <label for="question-input">Ask a Question</label>
                <input
                  type="text"
                  id="question-input"
                  bind:value={question}
                  placeholder="Type your question..."
                />
              </div>
            {:else if interactiveType === "slider"}
              <div class="slider-settings">
                <div class="slider-label-input">
                  <label for="slider-label-input">Slider Label</label>
                  <input
                    type="text"
                    id="slider-label-input"
                    bind:value={sliderLabel}
                    placeholder="e.g., Rate this from 1-10"
                  />
                </div>

                <div class="slider-range">
                  <label id="slider-range-label">Range</label>
                  <div
                    class="range-inputs"
                    aria-labelledby="slider-range-label"
                  >
                    <input
                      type="number"
                      id="slider-min"
                      bind:value={sliderMin}
                      placeholder="Min"
                      min="0"
                      aria-label="Minimum value"
                    />
                    <span>to</span>
                    <input
                      type="number"
                      id="slider-max"
                      bind:value={sliderMax}
                      placeholder="Max"
                      min="1"
                      aria-label="Maximum value"
                    />
                  </div>
                </div>
              </div>
            {/if}
          {/if}
        </div>
      </div>
    {/if}
  </div>

  <div class="creator-footer">
    <button
      class="cancel-button"
      on:click={() => navigate("/")}
      disabled={isSubmitting}
      type="button"
    >
      Cancel
    </button>
    <button
      class="create-button"
      on:click={createStory}
      disabled={!mediaFile || isSubmitting}
      type="button"
    >
      {isSubmitting ? "Creating..." : "Create Story"}
    </button>
  </div>
</div>

<style>
  .story-creator {
    display: flex;
    flex-direction: column;
    height: 100vh;
    background-color: var(--background);
  }

  .creator-header {
    padding: 16px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-bottom: 1px solid var(--light-gray);
    background-color: white;
  }

  .creator-header h1 {
    margin: 0;
    font-size: 1.2rem;
  }

  .close-button {
    background: none;
    border: none;
    font-size: 1.5rem;
    color: var(--charcoal);
    cursor: pointer;
  }

  .creator-content {
    flex: 1;
    overflow-y: auto;
    padding: 16px;
  }

  .error-message {
    background-color: #fff0f0;
    color: var(--tomato);
    padding: 10px;
    border-radius: 8px;
    margin-bottom: 16px;
  }

  .media-section {
    margin-bottom: 24px;
  }

  .media-upload {
    border: 2px dashed var(--light-gray);
    border-radius: 8px;
    padding: 40px 20px;
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
  }

  .upload-button {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 8px;
    background: none;
    border: none;
    color: var(--tomato);
    cursor: pointer;
  }

  .media-preview {
    position: relative;
    width: 100%;
    border-radius: 8px;
    overflow: hidden;
    aspect-ratio: 9/16;
    background-color: black;
  }

  .media-preview img,
  .media-preview video {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  .text-overlay {
    position: absolute;
    left: 0;
    right: 0;
    padding: 16px;
    text-align: center;
    text-shadow: 0 1px 3px rgba(0, 0, 0, 0.5);
    font-weight: bold;
  }

  .text-overlay.top {
    top: 16px;
  }

  .text-overlay.center {
    top: 50%;
    transform: translateY(-50%);
  }

  .text-overlay.bottom {
    bottom: 16px;
  }

  .remove-media {
    margin-top: 8px;
    background-color: var(--tomato);
    color: white;
    border: none;
    border-radius: 4px;
    padding: 8px 16px;
    cursor: pointer;
  }

  .settings-section {
    display: flex;
    flex-direction: column;
    gap: 24px;
  }

  .text-settings,
  .interactive-settings {
    background-color: white;
    border-radius: 8px;
    padding: 16px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  }

  h3 {
    margin-top: 0;
    margin-bottom: 12px;
    font-size: 1rem;
  }

  textarea {
    width: 100%;
    border: 1px solid var(--light-gray);
    border-radius: 8px;
    padding: 8px;
    resize: none;
  }

  .text-controls {
    margin-top: 12px;
    display: flex;
    flex-direction: column;
    gap: 12px;
  }

  .control-group {
    display: flex;
    align-items: center;
    gap: 8px;
  }

  .control-group label {
    min-width: 60px;
    font-size: 0.9rem;
  }

  .position-buttons,
  .size-buttons,
  .type-buttons {
    display: flex;
    gap: 4px;
  }

  .position-buttons button,
  .size-buttons button,
  .type-buttons button {
    background-color: var(--light-gray);
    border: none;
    border-radius: 4px;
    padding: 6px 12px;
    font-size: 0.9rem;
    color: var(--charcoal);
    cursor: pointer;
  }

  .position-buttons button.active,
  .size-buttons button.active,
  .type-buttons button.active {
    background-color: var(--tomato);
    color: white;
  }

  input[type="color"] {
    -webkit-appearance: none;
    appearance: none;
    width: 30px;
    height: 30px;
    border: none;
    border-radius: 4px;
    padding: 0;
    cursor: pointer;
  }

  .toggle-container {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 16px;
  }

  .interactive-type {
    margin-bottom: 16px;
  }

  .poll-options,
  .question-input,
  .slider-settings {
    margin-top: 16px;
  }

  .poll-option-input {
    display: flex;
    gap: 8px;
    margin-bottom: 8px;
  }

  .poll-option-input input {
    flex: 1;
    padding: 8px;
    border: 1px solid var(--light-gray);
    border-radius: 4px;
  }

  .remove-option {
    width: 30px;
    background-color: var(--light-gray);
    border: none;
    border-radius: 4px;
    padding: 0;
    font-size: 1.2rem;
    color: var(--charcoal);
    cursor: pointer;
  }

  .add-option {
    background: none;
    border: none;
    color: var(--tomato);
    padding: 0;
    margin-top: 8px;
    cursor: pointer;
    font-size: 0.9rem;
  }

  .question-input input,
  .slider-label-input input {
    width: 100%;
    padding: 8px;
    border: 1px solid var(--light-gray);
    border-radius: 4px;
    margin-top: 4px;
  }

  .slider-range {
    margin-top: 12px;
  }

  .range-inputs {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-top: 4px;
  }

  .range-inputs input {
    width: 60px;
    padding: 8px;
    border: 1px solid var(--light-gray);
    border-radius: 4px;
  }

  .interactive-preview {
    position: absolute;
    bottom: 60px;
    left: 16px;
    right: 16px;
    background-color: rgba(0, 0, 0, 0.5);
    border-radius: 8px;
    padding: 12px;
    color: white;
  }

  .poll-preview {
    display: flex;
    flex-direction: column;
    gap: 8px;
  }

  .poll-preview .poll-option {
    background-color: rgba(255, 255, 255, 0.2);
    padding: 8px;
    border-radius: 4px;
    text-align: center;
  }

  .question-preview {
    display: flex;
    flex-direction: column;
    gap: 8px;
  }

  .question-preview .question-text {
    font-weight: bold;
    margin-bottom: 4px;
  }

  .question-preview input {
    background-color: rgba(255, 255, 255, 0.2);
    border: none;
    border-radius: 4px;
    padding: 8px;
    color: white;
  }

  .slider-preview {
    display: flex;
    flex-direction: column;
    gap: 8px;
  }

  .slider-preview .slider-label {
    font-weight: bold;
    margin-bottom: 4px;
  }

  .slider-preview input[type="range"] {
    width: 100%;
    -webkit-appearance: none;
    appearance: none;
  }

  .slider-values {
    display: flex;
    justify-content: space-between;
    font-size: 0.8rem;
  }

  .creator-footer {
    padding: 16px;
    display: flex;
    justify-content: space-between;
    gap: 12px;
    background-color: white;
    border-top: 1px solid var(--light-gray);
  }

  .cancel-button,
  .create-button {
    flex: 1;
    padding: 12px;
    border-radius: 8px;
    font-weight: 600;
    cursor: pointer;
  }

  .cancel-button {
    background-color: var(--light-gray);
    border: none;
    color: var(--charcoal);
  }

  .create-button {
    background-color: var(--tomato);
    border: none;
    color: white;
  }

  .create-button:disabled {
    background-color: var(--gray);
    cursor: not-allowed;
  }
</style>
