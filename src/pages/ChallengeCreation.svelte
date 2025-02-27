<script>
  import { showChallengeCreation } from "../stores.js";
  import { supabase } from "../supabase.js";

  let title = "";
  let type = "Solo";
  let participantsMax = 10;
  let cost = 0;
  let prizePool = 0;
  let scoringType = "Points";
  let isPublic = true;

  async function createChallenge() {
    const user = (await supabase.auth.getUser()).data.user;
    if (!user) {
      console.error("User not logged in");
      return;
    }

    const { data, error } = await supabase.from("challenges").insert([
      {
        title,
        type,
        participants_max: participantsMax,
        cost,
        prize_pool: prizePool,
        scoring_type: scoringType,
        is_public: isPublic,
        created_by: user.id,
        participants_current: 1,
      },
    ]);

    if (error) {
      console.error("Error creating challenge:", error);
    } else {
      console.log("Challenge created:", data);
      $showChallengeCreation = false;
    }
  }

  function closeModal() {
    $showChallengeCreation = false;
  }
</script>

<div class="modal">
  <div class="modal-content">
    <h2>Create a New Challenge</h2>
    <form on:submit|preventDefault={createChallenge}>
      <label>
        Title:
        <input type="text" bind:value={title} required />
      </label>
      <label>
        Type:
        <select bind:value={type}>
          <option value="Solo">Solo</option>
          <option value="Group">Group</option>
        </select>
      </label>
      <label>
        Max Participants:
        <input type="number" bind:value={participantsMax} min="1" required />
      </label>
      <label>
        Cost ($):
        <input type="number" bind:value={cost} min="0" step="0.01" required />
      </label>
      <label>
        Prize Pool ($):
        <input
          type="number"
          bind:value={prizePool}
          min="0"
          step="0.01"
          required
        />
      </label>
      <label>
        Scoring Type:
        <select bind:value={scoringType}>
          <option value="Points">Points</option>
          <option value="Time">Time</option>
        </select>
      </label>
      <label>
        Public:
        <input type="checkbox" bind:checked={isPublic} />
      </label>
      <button type="submit">Create Challenge</button>
      <button type="button" on:click={closeModal}>Cancel</button>
    </form>
  </div>
</div>

<style>
  .modal {
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
    color: var(--text);
    padding: 2rem;
    border-radius: 8px;
    max-width: 500px;
    width: 90%;
    max-height: 80vh;
    overflow-y: auto;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
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
    background-color: var(--white);
    color: var(--charcoal);
  }

  button {
    background-color: var(--tomato);
    color: var(--background);
    border: none;
    padding: 0.75rem 1.5rem;
    border-radius: 4px;
    cursor: pointer;
    font-size: 1rem;
  }

  button:hover {
    background-color: var(--tomato-light);
  }

  button[type="button"] {
    background-color: var(--gray);
  }

  button[type="button"]:hover {
    background-color: darken(var(--gray), 10%);
  }
</style>
