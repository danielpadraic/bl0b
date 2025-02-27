<script>
  import { showChallengeCreation } from "../stores.js";
  import { supabase } from "../supabase.js";
  import { v4 as uuidv4 } from "uuid";

  // Form variables
  let title = "";
  let challengeType = "Fitness";
  let otherType = "";
  let maxParticipants = 0;
  let buyInCost = 0;
  let additionalPrizeMoney = 0;
  let prizeType = "just_for_fun";
  let prizeAmount = 0;
  let numberOfWinners = 1;
  let scoringType = "Consistency";
  let otherScoringType = "";
  let isPrivate = false;
  let creatorParticipating = "yes"; // Default to "Yes"

  // Handle form submission
  async function createChallenge(e) {
    e.preventDefault();

    // Validate required fields
    if (!title) {
      alert("Challenge Title is required.");
      return;
    }
    if (challengeType === "Other" && !otherType.trim()) {
      alert("Please specify the Other challenge type.");
      return;
    }
    if (prizeType === "set_amount" && (!prizeAmount || prizeAmount <= 0)) {
      alert("Please enter a valid prize amount greater than 0.");
      return;
    }
    if (
      prizeType === "evenly_distributed" &&
      (!numberOfWinners || numberOfWinners <= 0)
    ) {
      alert("Please specify a valid number of winners greater than 0.");
      return;
    }
    if (scoringType === "Other" && !otherScoringType.trim()) {
      alert("Please describe the Other scoring type.");
      return;
    }

    // Determine final challenge type
    let finalChallengeType =
      challengeType === "Other" ? otherType.trim() : challengeType;

    // Determine final scoring type
    let finalScoringType =
      scoringType === "Other" ? otherScoringType.trim() : scoringType;

    // Generate invitation link if private
    let invitationLink = null;
    if (isPrivate) {
      const uuid = uuidv4();
      invitationLink = `/join/${uuid}`;
    }

    // Determine participants_current based on creator participation
    const participantsCurrent = creatorParticipating === "yes" ? 1 : 0;

    // Prepare data for Supabase
    const challengeData = {
      title,
      type: finalChallengeType,
      participants_max: maxParticipants,
      buy_in_cost: parseFloat(buyInCost) || 0,
      additional_prize_money: parseFloat(additionalPrizeMoney) || 0,
      prize_type: prizeType,
      prize_amount:
        prizeType === "set_amount" ? parseFloat(prizeAmount) || 0 : null,
      number_of_winners:
        prizeType === "evenly_distributed" ? numberOfWinners : null,
      scoring_type: finalScoringType,
      is_private: isPrivate,
      invitation_link: invitationLink,
      created_by: (await supabase.auth.getUser()).data.user?.id,
      participants_current: participantsCurrent,
    };

    // Insert into Supabase
    const { error } = await supabase.from("challenges").insert([challengeData]);

    if (error) {
      console.error("Error creating challenge:", error.message);
      alert("Failed to create challenge: " + error.message);
    } else {
      console.log("Challenge created successfully");
      $showChallengeCreation = false;
      resetForm();
    }
  }

  // Reset form fields
  function resetForm() {
    title = "";
    challengeType = "Fitness";
    otherType = "";
    maxParticipants = 0;
    buyInCost = 0;
    additionalPrizeMoney = 0;
    prizeType = "just_for_fun";
    prizeAmount = 0;
    numberOfWinners = 1;
    scoringType = "Consistency";
    otherScoringType = "";
    isPrivate = false;
    creatorParticipating = "yes"; // Reset to default "Yes"
  }

  // Close modal without saving
  function closeModal(event) {
    if (
      event.type === "click" ||
      (event.type === "keydown" && event.key === "Escape")
    ) {
      $showChallengeCreation = false;
      resetForm();
    }
  }
</script>

{#if $showChallengeCreation}
  <div
    class="modal-overlay"
    on:click={closeModal}
    on:keydown={closeModal}
    role="dialog"
    aria-modal="true"
    tabindex="0"
  >
    <div class="modal-content" on:click|stopPropagation>
      <h2>Create a New Challenge</h2>
      <form on:submit={createChallenge}>
        <!-- Challenge Title -->
        <label>
          Challenge Title:
          <input
            type="text"
            bind:value={title}
            required
            placeholder="Enter challenge title"
          />
        </label>

        <!-- Challenge Type -->
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

        <!-- Number of Participants -->
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

        <!-- Creator Participation -->
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

        <!-- Buy-In Cost -->
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

        <!-- Additional Prize Money -->
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

        <!-- Prize Type -->
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

        <!-- Scoring Type -->
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

        <!-- Private Challenge -->
        <label>
          Private Challenge:
          <input type="checkbox" bind:checked={isPrivate} />
          {#if isPrivate}
            <small>A unique invitation link will be generated.</small>
          {/if}
        </label>

        <!-- Form Buttons -->
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
    padding: 2rem;
    border-radius: 8px;
    max-width: 500px;
    width: 90%;
    max-height: 80vh;
    overflow-y: auto;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    color: var(--text);
  }

  h2 {
    margin-top: 0;
    color: var(--text);
    font-size: clamp(1.5rem, 3vw, 2rem);
  }

  form {
    display: flex;
    flex-direction: column;
    gap: 1rem;
  }

  label {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
  }

  input,
  select {
    padding: 0.5rem;
    border: 1px solid var(--light-gray);
    border-radius: 4px;
    font-size: 1rem;
    background-color: var(--white);
    color: var(--charcoal);
  }

  .radio-group {
    display: flex;
    gap: 1rem;
    margin-top: 0.5rem;
  }

  .radio-group label {
    flex-direction: row;
    align-items: center;
    gap: 0.5rem;
  }

  small {
    color: var(--gray);
    font-size: 0.9rem;
  }

  .buttons {
    display: flex;
    gap: 1rem;
    margin-top: 1rem;
    justify-content: flex-end;
  }

  button {
    padding: 0.75rem 1.5rem;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 1rem;
  }

  button[type="submit"] {
    background-color: var(--tomato);
    color: var(--background);
  }

  button[type="submit"]:hover {
    background-color: var(--tomato-light);
  }

  button[type="button"] {
    background-color: var(--gray);
    color: var(--background);
  }

  button[type="button"]:hover {
    background-color: darken(var(--gray), 10%);
  }
</style>
