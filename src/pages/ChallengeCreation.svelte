<script>
  import { onMount } from "svelte";
  import { showChallengeCreation, user } from "../stores.js";
  import { supabase } from "../supabase.js";

  let title = "";
  let challengeType = "Fitness";
  let otherType = "";
  let maxParticipants = 0;
  let creatorParticipating = "yes";
  let buyInCost = 0;
  let additionalPrizeMoney = 0;
  let prizeType = "just_for_fun";
  let prizeAmount = 0;
  let numberOfWinners = 1;
  let scoringType = "Consistency";
  let otherScoringType = "";
  let isPrivate = false;
  let coverFile = null; // For photo/video upload
  let errorMessage = "";

  function resetForm() {
    title = "";
    challengeType = "Fitness";
    otherType = "";
    maxParticipants = 0;
    creatorParticipating = "yes";
    buyInCost = 0;
    additionalPrizeMoney = 0;
    prizeType = "just_for_fun";
    prizeAmount = 0;
    numberOfWinners = 1;
    scoringType = "Consistency";
    otherScoringType = "";
    isPrivate = false;
    coverFile = null;
    errorMessage = "";
  }

  async function createChallenge(event) {
    event.preventDefault();
    try {
      let coverUrl = null;
      if (coverFile) {
        const fileName = `${Date.now()}-${coverFile.name}`;
        const { data, error: uploadError } = await supabase.storage
          .from("challenge-covers")
          .upload(fileName, coverFile);
        if (uploadError) throw uploadError;
        coverUrl = `${supabase.storageUrl}/object/public/challenge-covers/${fileName}`;
      }

      const challengeData = {
        title,
        type: challengeType === "Other" ? otherType : challengeType,
        participants_max: maxParticipants,
        creator_participating: creatorParticipating === "yes",
        buy_in_cost: buyInCost,
        additional_prize_money: additionalPrizeMoney,
        prize_type: prizeType,
        prize_amount: prizeType === "set_amount" ? prizeAmount : null,
        number_of_winners:
          prizeType === "evenly_distributed" ? numberOfWinners : null,
        scoring_type: scoringType === "Other" ? otherScoringType : scoringType,
        is_private: isPrivate,
        cover_media: coverUrl,
        creator_id: $user.id,
      };

      const { error } = await supabase
        .from("challenges")
        .insert([challengeData]);
      if (error) throw error;

      if (creatorParticipating === "yes") {
        await supabase
          .from("challenge_participants")
          .insert([
            {
              challenge_id: (
                await supabase
                  .from("challenges")
                  .select("id")
                  .eq("title", title)
                  .single()
              ).data.id,
              user_id: $user.id,
            },
          ]);
      }

      $showChallengeCreation = false;
      resetForm();
    } catch (error) {
      errorMessage = error.message;
    }
  }

  function closeModal(event) {
    if (
      event.type === "click" ||
      (event.type === "keydown" && event.key === "Escape")
    ) {
      $showChallengeCreation = false;
      resetForm();
    }
  }

  function handleFileChange(event) {
    coverFile = event.target.files[0];
  }
</script>

{#if $showChallengeCreation}
  <div class="modal-overlay" on:click={closeModal} on:keydown={closeModal}>
    <div class="modal-content" on:click|stopPropagation>
      <h2>Create a New Challenge</h2>
      {#if errorMessage}
        <p class="error">{errorMessage}</p>
      {/if}
      <form on:submit={createChallenge}>
        <label>
          Challenge Title:
          <input
            type="text"
            bind:value={title}
            required
            placeholder="Enter challenge title"
          />
        </label>

        <label>
          Challenge Type:
          <select bind:value={challengeType}>
            <option value="Fitness">Fitness</option>
            <option value="Other">Other</option>
          </select>
          {#if challengeType === "Other"}
            <input
              type="text"
              bind:value={otherType}
              placeholder="Specify challenge type"
              required
            />
          {/if}
        </label>

        <label>
          Number of Participants (0 for unlimited):
          <input
            type="number"
            bind:value={maxParticipants}
            min="0"
            placeholder="0"
          />
          {#if maxParticipants === 1}
            <small>Only you can join this challenge.</small>
          {/if}
        </label>

        <label>
          Will you be participating in this Challenge?
          <div class="radio-group">
            <label>
              <input
                type="radio"
                bind:group={creatorParticipating}
                value="yes"
                checked
              />
              Yes
            </label>
            <label>
              <input
                type="radio"
                bind:group={creatorParticipating}
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
            bind:value={buyInCost}
            step="0.01"
            min="0"
            placeholder="0.00"
          />
        </label>

        <label>
          Additional Prize Money ($):
          <input
            type="number"
            bind:value={additionalPrizeMoney}
            step="0.01"
            min="0"
            placeholder="0.00"
          />
        </label>

        <label>
          Prize:
          <select bind:value={prizeType}>
            <option value="just_for_fun">Just for Fun</option>
            <option value="set_amount">Set Amount</option>
            <option value="winner_takes_all">Winner Takes All</option>
            <option value="evenly_distributed">Evenly Distributed</option>
            <option value="tournament">Tournament Style</option>
          </select>
          {#if prizeType === "set_amount"}
            <input
              type="number"
              bind:value={prizeAmount}
              step="0.01"
              min="0"
              placeholder="Prize amount"
              required
            />
          {/if}
          {#if prizeType === "evenly_distributed"}
            <input
              type="number"
              bind:value={numberOfWinners}
              min="1"
              placeholder="Number of winners"
              required
            />
          {/if}
          {#if prizeType === "tournament"}
            <small
              >Prizes calculated based on participant count at challenge end.</small
            >
          {/if}
        </label>

        <label>
          Scoring Type:
          <select bind:value={scoringType}>
            <option value="Consistency">Consistency</option>
            <option value="Time">Time</option>
            <option value="Distance">Distance</option>
            <option value="Points">Points</option>
            <option value="Other">Other</option>
            <option value="None">None</option>
          </select>
          {#if scoringType === "Other"}
            <input
              type="text"
              bind:value={otherScoringType}
              placeholder="Describe scoring type"
              required
            />
          {/if}
        </label>

        <label>
          Private Challenge:
          <input type="checkbox" bind:checked={isPrivate} />
          {#if isPrivate}
            <small>A unique invitation link will be generated.</small>
          {/if}
        </label>

        <label>
          Cover Photo/Video:
          <input
            type="file"
            accept="image/*,video/*"
            on:change={handleFileChange}
          />
        </label>

        <div class="buttons">
          <button type="submit">Create Challenge</button>
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
