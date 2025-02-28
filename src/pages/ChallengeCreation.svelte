<script>
  import { onMount, onDestroy } from "svelte";
  import { navigate } from "svelte-routing";
  import { writable } from "svelte/store";
  import { showChallengeCreation, user } from "../stores.js";
  import { supabase } from "../supabase.js";

  export let challenge = null;
  export let editMode = false;

  let form = {
    title: "",
    challengeType: "Fitness",
    otherType: "",
    maxParticipants: 0,
    creatorParticipating: "yes",
    buyInCost: 0,
    additionalPrizeMoney: 0,
    prizeType: "just_for_fun",
    prizeAmount: 0,
    numberOfWinners: 1,
    scoringType: "Consistency",
    otherScoringType: "",
    isPrivate: false,
    coverFile: null,
    startDateTime: "",
    endDateTime: "",
    errorMessage: "",
    showStartPicker: false,
    showEndPicker: false,
  };

  const formData = writable({ ...form });

  onMount(() => {
    console.log(
      "ChallengeCreation mounted. editMode:",
      editMode,
      "challenge:",
      challenge
    );
    if (editMode && challenge) {
      console.log("Populating form with challenge data:", challenge);
      // Replace entire form object to trigger reactivity
      const newFormState = {
        title: challenge.title || "",
        challengeType: ["Fitness"].includes(challenge.type)
          ? challenge.type
          : "Other",
        otherType: ["Fitness"].includes(challenge.type)
          ? ""
          : challenge.type || "",
        maxParticipants: challenge.participants_max || 0,
        creatorParticipating: challenge.creator_participating ? "yes" : "no",
        buyInCost: challenge.buy_in_cost || 0,
        additionalPrizeMoney: challenge.additional_prize_money || 0,
        prizeType: challenge.prize_type || "just_for_fun",
        prizeAmount: challenge.prize_amount || 0,
        numberOfWinners: challenge.number_of_winners || 1,
        scoringType: [
          "Consistency",
          "Time (High)",
          "Time (Low)",
          "Distance",
          "Points",
          "None",
        ].includes(challenge.scoring_type)
          ? challenge.scoring_type
          : "Other",
        otherScoringType: [
          "Consistency",
          "Time (High)",
          "Time (Low)",
          "Distance",
          "Points",
          "None",
        ].includes(challenge.scoring_type)
          ? ""
          : challenge.scoring_type || "",
        isPrivate: challenge.is_private || false,
        coverFile: null,
        startDateTime: challenge.start_datetime
          ? new Date(challenge.start_datetime).toISOString().slice(0, 16)
          : "",
        endDateTime: challenge.end_datetime
          ? new Date(challenge.end_datetime).toISOString().slice(0, 16)
          : "",
        errorMessage: "",
        showStartPicker: false,
        showEndPicker: false,
      };
      // Force DOM update after initial render
      setTimeout(() => {
        form = newFormState;
        console.log("Form fields set:", form);
      }, 0);
    } else {
      console.log("Create mode: Loading persisted form data");
      form = { ...$formData };
    }
  });

  onDestroy(() => {
    if (!editMode) {
      console.log("Saving form data to store for create mode");
      formData.set({ ...form });
    }
  });

  async function submitChallenge(event) {
    event.preventDefault();

    const now = new Date();
    const start = form.startDateTime ? new Date(form.startDateTime) : null;
    const end = form.endDateTime ? new Date(form.endDateTime) : null;

    if (start && start < now) {
      form.errorMessage = "Start date and time cannot be in the past.";
      return;
    }
    if (end && end < now) {
      form.errorMessage = "End date and time cannot be in the past.";
      return;
    }
    if (start && end && end <= start) {
      form.errorMessage =
        "End date and time must be after start date and time.";
      return;
    }

    try {
      let coverUrl = challenge ? challenge.cover_media : null;
      if (form.coverFile) {
        const fileName = `${Date.now()}-${form.coverFile.name}`;
        console.log(
          "Uploading file:",
          fileName,
          "Size:",
          form.coverFile.size,
          "Type:",
          form.coverFile.type
        );
        const { data, error: uploadError } = await supabase.storage
          .from("challenge-covers")
          .upload(fileName, form.coverFile, {
            cacheControl: "3600",
            upsert: false,
          });
        if (uploadError) {
          console.error("Upload error:", uploadError);
          throw new Error(`Failed to upload image: ${uploadError.message}`);
        }
        console.log("Upload successful:", data);
        coverUrl = supabase.storage
          .from("challenge-covers")
          .getPublicUrl(fileName).data.publicUrl;
      }

      const challengeData = {
        title: form.title,
        type:
          form.challengeType === "Other" ? form.otherType : form.challengeType,
        participants_max: form.maxParticipants,
        creator_participating: form.creatorParticipating === "yes",
        buy_in_cost: form.buyInCost,
        additional_prize_money: form.additionalPrizeMoney,
        prize_type: form.prizeType,
        prize_amount: form.prizeType === "set_amount" ? form.prizeAmount : null,
        number_of_winners:
          form.prizeType === "evenly_distributed" ? form.numberOfWinners : null,
        scoring_type:
          form.scoringType === "Other"
            ? form.otherScoringType
            : form.scoringType,
        is_private: form.isPrivate,
        cover_media: coverUrl,
        creator_id: $user.id,
        start_datetime: form.startDateTime || null,
        end_datetime: form.endDateTime || null,
      };

      let newChallenge;
      if (editMode && challenge) {
        const { data, error } = await supabase
          .from("challenges")
          .update(challengeData)
          .eq("id", challenge.id)
          .select()
          .single();
        if (error) throw error;
        newChallenge = data;
      } else {
        const { data, error } = await supabase
          .from("challenges")
          .insert([challengeData])
          .select()
          .single();
        if (error) throw error;
        newChallenge = data;

        if (form.creatorParticipating === "yes") {
          await supabase
            .from("challenge_participants")
            .insert([{ challenge_id: newChallenge.id, user_id: $user.id }]);
        }
      }

      $showChallengeCreation = false;
      resetForm();
      navigate(`/challenge/${newChallenge.id}`);
    } catch (error) {
      form.errorMessage = error.message;
      console.error("Challenge submission error:", error);
    }
  }

  function resetForm() {
    form = {
      title: "",
      challengeType: "Fitness",
      otherType: "",
      maxParticipants: 0,
      creatorParticipating: "yes",
      buyInCost: 0,
      additionalPrizeMoney: 0,
      prizeType: "just_for_fun",
      prizeAmount: 0,
      numberOfWinners: 1,
      scoringType: "Consistency",
      otherScoringType: "",
      isPrivate: false,
      coverFile: null,
      startDateTime: "",
      endDateTime: "",
      errorMessage: "",
      showStartPicker: false,
      showEndPicker: false,
    };
    if (!editMode) {
      formData.set({ ...form });
    }
  }

  function closeModal(event) {
    if (
      event.type === "click" ||
      (event.type === "keydown" && event.key === "Escape")
    ) {
      $showChallengeCreation = false;
    }
  }

  function handleFileChange(event) {
    form.coverFile = event.target.files[0];
    console.log("Selected file:", form.coverFile);
  }

  function confirmStartDate() {
    form.showStartPicker = false;
  }

  function confirmEndDate() {
    form.showEndPicker = false;
  }
</script>

{#if $showChallengeCreation}
  <div class="modal-overlay" on:click={closeModal} on:keydown={closeModal}>
    <div
      class="modal-content"
      on:click|stopPropagation
      on:keydown|stopPropagation={() => {}}
    >
      <h2>{editMode ? "Edit Challenge" : "Create a New Challenge"}</h2>
      {#if form.errorMessage}
        <p class="error">{form.errorMessage}</p>
      {/if}
      <form on:submit={submitChallenge}>
        <label>
          Challenge Title:
          <input
            type="text"
            bind:value={form.title}
            required
            placeholder="Enter challenge title"
          />
        </label>

        <label>
          Challenge Type:
          <select bind:value={form.challengeType}>
            <option value="Fitness">Fitness</option>
            <option value="Other">Other</option>
          </select>
          {#if form.challengeType === "Other"}
            <input
              type="text"
              bind:value={form.otherType}
              placeholder="Specify challenge type"
              required
            />
          {/if}
        </label>

        <label>
          Number of Participants (0 for unlimited):
          <input
            type="number"
            bind:value={form.maxParticipants}
            min="0"
            placeholder="0"
          />
          {#if form.maxParticipants === 1}
            <small>Only you can join this challenge.</small>
          {/if}
        </label>

        <label>
          Will you be participating in this Challenge?
          <div class="radio-group">
            <label>
              <input
                type="radio"
                bind:group={form.creatorParticipating}
                value="yes"
              />
              Yes
            </label>
            <label>
              <input
                type="radio"
                bind:group={form.creatorParticipating}
                value="no"
              />
              No
            </label>
          </div>
        </label>

        <label>
          Buy-In Cost ($):
          <input
            type="number"
            bind:value={form.buyInCost}
            step="0.01"
            min="0"
            placeholder="0.00"
          />
        </label>

        <label>
          Additional Prize Money ($):
          <input
            type="number"
            bind:value={form.additionalPrizeMoney}
            step="0.01"
            min="0"
            placeholder="0.00"
          />
        </label>

        <label>
          Prize:
          <select bind:value={form.prizeType}>
            <option value="just_for_fun">Just for Fun</option>
            <option value="set_amount">Set Amount</option>
            <option value="winner_takes_all">Winner Takes All</option>
            <option value="evenly_distributed">Evenly Distributed</option>
            <option value="tournament">Tournament Style</option>
          </select>
          {#if form.prizeType === "set_amount"}
            <input
              type="number"
              bind:value={form.prizeAmount}
              step="0.01"
              min="0"
              placeholder="Prize amount"
              required
            />
          {/if}
          {#if form.prizeType === "evenly_distributed"}
            <input
              type="number"
              bind:value={form.numberOfWinners}
              min="1"
              placeholder="Number of winners"
              required
            />
          {/if}
          {#if form.prizeType === "tournament"}
            <small
              >Prizes calculated based on participant count at challenge end.</small
            >
          {/if}
        </label>

        <label>
          Scoring Type:
          <select bind:value={form.scoringType}>
            <option value="Consistency">Consistency</option>
            <option value="Time (High)">Time (High)</option>
            <option value="Time (Low)">Time (Low)</option>
            <option value="Distance">Distance</option>
            <option value="Points">Points</option>
            <option value="Other">Other</option>
            <option value="None">None</option>
          </select>
          {#if form.scoringType === "Other"}
            <input
              type="text"
              bind:value={form.otherScoringType}
              placeholder="Describe scoring type"
              required
            />
          {/if}
        </label>

        <label>
          Private Challenge:
          <input type="checkbox" bind:checked={form.isPrivate} />
          {#if form.isPrivate}
            <small>A unique invitation link will be generated.</small>
          {/if}
        </label>

        <label>
          Start Date & Time:
          <input
            type="datetime-local"
            bind:value={form.startDateTime}
            step="900"
            required
            on:focus={() => (form.showStartPicker = true)}
          />
          {#if form.showStartPicker}
            <button type="button" on:click={confirmStartDate}>OK</button>
          {/if}
        </label>

        <label>
          End Date & Time:
          <input
            type="datetime-local"
            bind:value={form.endDateTime}
            step="900"
            required
            on:focus={() => (form.showEndPicker = true)}
          />
          {#if form.showEndPicker}
            <button type="button" on:click={confirmEndDate}>OK</button>
          {/if}
        </label>

        <label>
          Cover Photo/Video:
          <input
            type="file"
            accept="image/*,video/*"
            on:change={handleFileChange}
          />
          {#if editMode && challenge.cover_media && !form.coverFile}
            <small
              >Current: <a href={challenge.cover_media} target="_blank">View</a
              ></small
            >
          {/if}
        </label>

        <div class="buttons">
          <button type="submit"
            >{editMode ? "Save Changes" : "Create Challenge"}</button
          >
          <button type="button" on:click={closeModal}>Cancel</button>
        </div>
      </form>
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
    background: var(--background);
    padding: 1rem;
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
    max-width: 500px;
    width: 90%;
    max-height: 80vh;
    overflow-y: auto;
    color: var(--text);
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
    position: relative;
  }

  input,
  select {
    width: 100%;
    padding: 0.5rem;
    margin-top: 0.25rem;
    border: 1px solid var(--light-gray);
    border-radius: 4px;
    background-color: var(--white);
    color: var(--charcoal);
    font-size: 0.9rem;
  }

  input[type="datetime-local"] + button {
    position: absolute;
    right: 0.5rem;
    top: 50%;
    transform: translateY(-50%);
    padding: 0.2rem 0.5rem;
    font-size: 0.8rem;
  }

  .radio-group {
    display: flex;
    gap: 1rem;
    margin-top: 0.25rem;
  }

  small {
    display: block;
    color: var(--gray);
    font-size: 0.8rem;
    margin-top: 0.25rem;
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
