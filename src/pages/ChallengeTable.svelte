<script>
  import { user } from "../stores/user.js";
  import { navigate } from "svelte-routing";

  export let challenges = [];
  export let loading = false;
  export let error = null;

  function joinChallenge(challengeId) {
    if (!$user) return;
    console.log(`Joining challenge ${challengeId}`);
    // Implement join logic later
  }
</script>

<div class="challenge-table">
  <h2>Challenge Lobby</h2>
  {#if loading}
    <p>Loading challenges...</p>
  {:else if error}
    <p class="error">Error: {error}</p>
  {:else}
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
        {#if challenges.length > 0}
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
              <button
                on:click={() => navigate("/create-challenge")}
                class="create-btn">Create Challenge</button
              >
            </td>
          </tr>
        {/if}
      </tbody>
    </table>
  {/if}
</div>

<style>
  .challenge-table {
    padding: 1rem;
  }

  table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 1rem;
  }

  th,
  td {
    padding: 0.75rem;
    border: 1px solid var(--charcoal);
    text-align: left;
  }

  th {
    background-color: var(--tomato);
    color: var(--white);
  }

  tr:nth-child(even) {
    background-color: var(--light-gray);
  }

  tr:hover {
    background-color: var(--tomato-light);
  }

  .no-challenges {
    text-align: center;
    padding: 2rem;
  }

  button {
    background-color: var(--tomato);
    color: var(--white);
    border: none;
    padding: 0.5rem 1rem;
    border-radius: 4px;
    cursor: pointer;
    margin-top: 1rem;
  }

  button:disabled {
    background-color: var(--gray);
    cursor: not-allowed;
  }

  button:hover:not(:disabled) {
    background-color: var(--tomato-light);
  }

  .error {
    color: var(--hunyadi-yellow);
  }
</style>
