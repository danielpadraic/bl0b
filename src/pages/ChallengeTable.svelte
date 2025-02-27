<script>
  import { showChallengeCreation } from "../stores.js";

  export let challenges = [];
  export let loading = false;
  export let error = null;

  function toggleChallengeCreation() {
    $showChallengeCreation = !$showChallengeCreation;
    console.log(
      "Toggling challenge creation modal from table:",
      $showChallengeCreation
    );
  }

  function joinChallenge(challengeId) {
    console.log(`Joining challenge ${challengeId}`);
  }
</script>

<div class="challenge-table">
  <h2>Challenge Lobby</h2>
  <div class="table-wrapper">
    <table>
      <thead>
        <tr>
          <th>Title</th>
          <th>Type</th>
          <th>Participants</th>
          <th>Cost</th>
          <th>Prize</th>
          <th>Scoring Type</th>
          <th>Privacy</th>
          <th>Action</th>
        </tr>
      </thead>
      <tbody>
        {#if loading}
          <tr>
            <td colspan="8">Loading challenges...</td>
          </tr>
        {:else if error}
          <tr>
            <td colspan="8" class="error">Error: {error}</td>
          </tr>
        {:else if challenges.length > 0}
          {#each challenges as challenge}
            <tr>
              <td data-label="Title">{challenge.title}</td>
              <td data-label="Type">{challenge.type}</td>
              <td data-label="Participants"
                >{challenge.participants_current}/{challenge.participants_max}</td
              >
              <td data-label="Cost">${challenge.cost.toFixed(2)}</td>
              <td data-label="Prize">${challenge.prize_pool.toFixed(2)}</td>
              <td data-label="Scoring Type">{challenge.scoring_type}</td>
              <td data-label="Privacy"
                >{challenge.is_public ? "Public" : "Private"}</td
              >
              <td data-label="Action">
                <button
                  on:click={() => joinChallenge(challenge.id)}
                  disabled={challenge.participants_current >=
                    challenge.participants_max &&
                    challenge.participants_max !== "Unlimited"}
                >
                  Join
                </button>
              </td>
            </tr>
          {/each}
        {:else}
          <tr>
            <td colspan="8" class="no-challenges">
              <div class="no-challenges-content">
                <span>No Challenges Available</span>
                <button on:click={toggleChallengeCreation} class="create-btn"
                  >Create Challenge</button
                >
              </div>
            </td>
          </tr>
        {/if}
      </tbody>
    </table>
  </div>
</div>

<style>
  .challenge-table {
    width: 100%;
    max-width: 1200px;
    margin: 0 auto;
    padding: 1rem;
    background-color: var(--background);
    color: var(--text);
  }

  h2 {
    text-align: center;
    margin-bottom: 1rem;
    color: var(--text);
    font-size: clamp(1rem, 4vw, 2rem);
  }

  .table-wrapper {
    overflow-x: auto;
    -webkit-overflow-scrolling: touch;
  }

  table {
    width: 100%;
    min-width: 600px;
    border-collapse: collapse;
    background-color: var(--white);
    color: var(--charcoal);
    font-size: clamp(0.75rem, 2vw, 1rem);
  }

  th,
  td {
    padding: clamp(0.5rem, 2vw, 1rem);
    border: 1px solid var(--light-gray);
  }

  th {
    background-color: var(--carolina-blue);
    color: var(--charcoal);
    font-size: clamp(0.8rem, 2.5vw, 1.2rem);
    text-align: center;
  }

  td {
    text-align: left;
  }

  .error {
    color: var(--tomato);
    text-align: center;
    padding: 1rem;
  }

  .no-challenges {
    text-align: center;
    padding: 2rem;
    color: var(--gray);
  }

  .no-challenges-content {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 1rem;
  }

  button {
    background-color: var(--tomato);
    color: var(--background);
    border: none;
    padding: clamp(0.4rem, 1.5vw, 0.75rem) clamp(0.8rem, 2vw, 1rem);
    border-radius: 4px;
    cursor: pointer;
    font-size: clamp(0.7rem, 1.5vw, 1rem);
  }

  button:disabled {
    background-color: var(--gray);
    cursor: not-allowed;
  }

  button:hover:not(:disabled) {
    background-color: var(--tomato-light);
  }

  .create-btn {
    background-color: var(--tomato);
    color: var(--background);
    padding: clamp(0.4rem, 1.5vw, 0.75rem) clamp(0.8rem, 2vw, 1rem);
    border-radius: 4px;
    cursor: pointer;
  }

  .create-btn:hover {
    background-color: var(--tomato-light);
  }
</style>
