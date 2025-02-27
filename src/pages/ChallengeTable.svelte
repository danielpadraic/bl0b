<script>
  import { user } from "../stores.js"; // Path from src/pages/
  import { createEventDispatcher } from "svelte";

  export let challenges = [];
  export let loading = false;
  export let error = null;
  export let searchQuery = "";
  const dispatch = createEventDispatcher();

  let sortColumn = null;
  let sortDirection = "asc";

  function toggleChallengeCreation() {
    console.log("Create Challenge clicked, user:", $user);
    dispatch("onCreate"); // Dispatching 'onCreate' event
    console.log("Dispatched onCreate event");
  }

  function joinChallenge(challengeId) {
    console.log("Join clicked for challenge:", challengeId, "user:", $user);
    dispatch("onJoin", challengeId); // Pass challengeId back to parent
    console.log("Dispatched onJoin event for challenge:", challengeId);
  }

  function sortChallenges(column) {
    console.log("Sorting by:", column);
    if (sortColumn === column) {
      sortDirection = sortDirection === "asc" ? "desc" : "asc";
    } else {
      sortColumn = column;
      sortDirection = "asc";
    }

    challenges = [...challenges].sort((a, b) => {
      let valueA = a[column];
      let valueB = b[column];

      if (column === "participants_max") {
        valueA = valueA === "Unlimited" ? Infinity : valueA;
        valueB = valueB === "Unlimited" ? Infinity : valueB;
      } else if (column === "is_public") {
        valueA = valueA ? 1 : 0;
        valueB = valueB ? 1 : 0;
      }

      if (typeof valueA === "string") valueA = valueA.toLowerCase();
      if (typeof valueB === "string") valueB = valueB.toLowerCase();

      if (sortDirection === "asc") {
        return valueA > valueB ? 1 : valueA < valueB ? -1 : 0;
      } else {
        return valueA < valueB ? 1 : valueA > valueB ? -1 : 0;
      }
    });
  }
</script>

<div class="challenge-table">
  <div class="table-wrapper">
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
          {#each challenges as challenge, index}
            <tr class={index % 2 === 0 ? "even-row" : "odd-row"}>
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
                  disabled={challenge.participants_max !== "Unlimited" &&
                    challenge.participants_current >=
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
              <div class="no-challenges-content">
                <span>No Challenges Available</span>
              </div>
            </td>
          </tr>
        {/if}
      </tbody>
    </table>
  </div>
  <div class="footer">
    <input
      type="text"
      bind:value={searchQuery}
      placeholder="Search by title, type, or cost..."
      class="search-input"
    />
    <button on:click={toggleChallengeCreation} class="create-btn"
      >Create Challenge</button
    >
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
    cursor: pointer;
  }

  th:hover {
    background-color: var(--tomato-light);
  }

  .even-row {
    background-color: var(--white);
  }

  .odd-row {
    background-color: var(--light-gray);
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

  .footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 1rem;
    gap: 1rem;
  }

  .search-input {
    padding: 0.5rem;
    border: 1px solid var(--light-gray);
    border-radius: 4px;
    font-size: 1rem;
    width: 100%;
    max-width: 300px;
    background-color: var(--white);
    color: var(--charcoal);
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
