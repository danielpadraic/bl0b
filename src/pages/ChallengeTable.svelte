<script>
  import { user, showChallengeCreation } from "../stores.js"; // Import the store
  import { navigate } from "svelte-routing";

  export let challenges = [];
  export let loading = false;
  export let error = null;

  function joinChallenge(challengeId) {
    if (!$user) return;
    console.log(`Joining challenge ${challengeId}`);
  }

  function toggleChallengeCreation() {
    $showChallengeCreation = true; // Open the modal
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
        {#if $user}
          <th>Action</th>
        {/if}
      </tr>
    </thead>
    <tbody>
      {#if loading}
        <tr>
          <td colspan={$user ? 8 : 7}>Loading challenges...</td>
        </tr>
      {:else if error}
        <tr>
          <td colspan={$user ? 8 : 7} class="error">Error: {error}</td>
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
            {#if $user}
              <td>
                <button
                  on:click={() => joinChallenge(challenge.id)}
                  disabled={challenge.participants_current >=
                    challenge.participants_max}
                >
                  Join
                </button>
              </td>
            {/if}
          </tr>
        {/each}
      {:else}
        <tr>
          <td colspan={$user ? 8 : 7} class="no-challenges">
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
  /* Keep your existing styles */
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
