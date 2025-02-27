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
  }
  h2 {
    text-align: center;
    margin-bottom: 20px;
  }
  table {
    width: 100%;
    border-collapse: collapse;
  }
  th,
  td {
    padding: 12px;
    text-align: left;
    border-bottom: 1px solid #ddd;
  }
  th {
    background-color: #f4f4f4;
  }
  .error {
    color: red;
    text-align: center;
  }
  .no-challenges {
    text-align: center;
    padding: 20px;
  }
  button {
    padding: 8px 16px;
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
  }
  button:disabled {
    background-color: #ccc;
    cursor: not-allowed;
  }
  button:hover:not(:disabled) {
    background-color: #0056b3;
  }
  .create-btn {
    background-color: #007bff;
    color: white;
    padding: 8px 16px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    margin-left: 10px;
  }
  .create-btn:hover {
    background-color: #0056b3;
  }
</style>
