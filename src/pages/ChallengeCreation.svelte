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
    background: white;
    padding: 20px;
    border-radius: 8px;
    width: 90%;
    max-width: 500px;
  }
  form {
    display: flex;
    flex-direction: column;
    gap: 15px;
  }
  label {
    display: flex;
    flex-direction: column;
    gap: 5px;
  }
  input,
  select {
    padding: 8px;
    border: 1px solid #ccc;
    border-radius: 4px;
  }
  button {
    padding: 10px;
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
  }
  button:hover {
    background-color: #0056b3;
  }
  button[type="button"] {
    background-color: #6c757d;
  }
  button[type="button"]:hover {
    background-color: #5a6268;
  }
</style>
