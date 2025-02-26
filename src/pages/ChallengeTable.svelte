<script>
  import { user } from "../stores/user.js";
  import { navigate } from "svelte-routing";
  import Fa from "svelte-fa"; // Updated import for FontAwesome
  import { faLock, faUnlock } from "@fortawesome/free-solid-svg-icons";

  export let challenges = [];
  export let loading = false;
  export let error = null;

  let sortColumn = "created_at";
  let sortDirection = "desc";

  function joinChallenge(challengeId) {
    if (!$user) return;
    console.log(`Joining challenge ${challengeId}`);
    // Implement join logic later
  }

  function sortChallenges(column) {
    if (sortColumn === column) {
      sortDirection = sortDirection === "asc" ? "desc" : "asc";
    } else {
      sortColumn = column;
      sortDirection = "asc";
    }
    challenges = [...challenges].sort((a, b) => {
      const aValue = a[column];
      const bValue = b[column];
      if (aValue < bValue) return sortDirection === "asc" ? -1 : 1;
      if (aValue > bValue) return sortDirection === "asc" ? 1 : -1;
      return 0;
    });
  }
</script>

<div class="challenge-table">
  {#if loading}
    <p>Loading challenges...</p>
  {:else if error}
    <p class="error">Error: {error}</p>
  {:else}
    <table>
      <thead>
        <tr>
          <th on:click={() => sortChallenges("title")}>Title</th>
          <th on:click={() => sortChallenges("type")}>Type</th>
          <th on:click={() => sortChallenges("participants_current")}
            >Participants</th
          >
          <th on:click={() => sortChallenges("cost")}>Cost</th>
          <th on:click={() => sortChallenges("prize_pool")}>Prize</th>
          <th on:click={() => sortChallenges("scoring_type")}>Scoring Type</th>
          <th on:click={() => sortChallenges("is_public")}>Privacy</th>
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
              <td>
                {#if challenge.is_public}
                  <Fa icon={faUnlock} />
                {:else}
                  <Fa icon={faLock} />
                {/if}
              </td>
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
                class="create-btn"
              >
                Create Challenge
              </button>
            </td>
          </tr>
        {/if}
      </tbody>
    </table>
  {/if}
</div>

<style>
  .challenge-table {
    padding: clamp(0.5rem, 2vw, 1rem);
    width: clamp(300px, 95vw, 1000px);
    margin: 0 auto;
  }

  table {
    width: 100%;
    border-collapse: collapse;
    font-size: clamp(0.8rem, 2vw, 1rem);
  }

  th,
  td {
    padding: clamp(0.5rem, 2vw, 0.75rem);
    border: 1px solid var(--charcoal);
    text-align: center;
  }

  th {
    background-color: var(--tomato);
    color: var(--white);
    cursor: pointer;
  }

  tr:nth-child(even) {
    background-color: var(--light-gray);
  }

  tr:hover {
    background-color: var(--tomato-light);
  }

  .no-challenges {
    padding: clamp(1rem, 3vw, 2rem);
    text-align: center;
    font-size: clamp(0.9rem, 2.5vw, 1.2rem);
  }

  button {
    background-color: var(--tomato);
    color: var(--white);
    border: none;
    padding: clamp(0.3rem, 1vw, 0.5rem) clamp(0.75rem, 2vw, 1rem);
    border-radius: 4px;
    cursor: pointer;
    font-size: clamp(0.8rem, 1.5vw, 1rem);
    margin-top: clamp(0.5rem, 1vw, 1rem);
    display: block;
    margin-left: auto;
    margin-right: auto;
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
    text-align: center;
    font-size: clamp(0.9rem, 2vw, 1.2rem);
  }
</style>
