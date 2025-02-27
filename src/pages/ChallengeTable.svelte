<script>
  import { showChallengeCreation } from "../stores.js";

  export let challenges = [];
  export let loading = false;
  export let error = null;

  function toggleChallengeCreation() {
    $showChallengeCreation = !$showChallengeCreation;
  }

  function joinChallenge(challengeId) {
    console.log(`Joining challenge ${challengeId}`);
  }
</script>

<div class="challenge-table">
  <h2>Challenge Lobby</h2>
  <table>
    <thead>
      <tr>
        <th>Title</th>
        <th>Type</th>
        <th>Participants</th>
        <th>Cost</th>
        <th>Prize Pool</th>
        <th>Scoring Type</th>
        <th>Public/Private</th>
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
            <td>{challenge.title}</td>
            <td>{challenge.type}</td>
            <td
              >{challenge.participants_current}/{challenge.participants_max}</td
            >
            <td>${challenge.cost.toFixed(2)}</td>
            <td>${challenge.prize_pool.toFixed(2)}</td>
            <td>{challenge.scoring_type}</td>
            <td>{challenge.is_public ? "Public" : "Private"}</td>
            <td>
              <button
                on:click={() => joinChallenge(challenge.id)}
                disabled={challenge.participants_current >=
                  challenge.participants_max}
              >
                Join
              </button>
            </td>
          </tr>
        {/each}
      {:else}
        <tr>
          <td colspan="8" class="no-challenges">
            No Challenges Available
            <button on:click={toggleChallengeCreation} class="create-btn"
              >Create Challenge</button
            >
          </td>
        </tr>
      {/if}
    </tbody>
  </table>
</div>

<style>
  .challenge-table {
    width: 100%;
    max-width: 1200px;
    margin: 0 auto;
    background-color: var(--background);
    color: var(--text);
  }

  h2 {
    text-align: center;
    margin-bottom: 1rem;
    color: var(--text);
  }

  table {
    width: 100%;
    border-collapse: collapse;
    background-color: var(--white);
    color: var(--charcoal);
  }

  th,
  td {
    padding: 0.75rem;
    text-align: left;
    border-bottom: 1px solid var(--light-gray);
  }

  th {
    background-color: var(--charcoal);
    color: var(--white);
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

  button {
    background-color: var(--tomato);
    color: var(--background);
    border: none;
    padding: 0.5rem 1rem;
    border-radius: 4px;
    cursor: pointer;
    font-size: 1rem;
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
    padding: 0.5rem 1rem;
    border-radius: 4px;
    cursor: pointer;
    margin-left: 1rem;
  }

  .create-btn:hover {
    background-color: var(--tomato-light);
  }
</style>
