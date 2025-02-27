<script>
  import { onMount } from "svelte";
  import { user } from "../stores.js";
  import { createEventDispatcher } from "svelte";

  export let challenges = [];
  export let loading = false;
  export let error = null;
  export let searchQuery = "";
  export let selectedTab = "All";

  const dispatch = createEventDispatcher();

  let sortColumn = null;
  let sortDirection = "asc";

  const tabs = ["All", "Fitness", "Other", "Friends", "Public", "Private"];

  function toggleChallengeCreation() {
    dispatch("onCreate");
  }

  function joinChallenge(challengeId) {
    dispatch("onJoin", challengeId);
  }

  function sortChallenges(column) {
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

  $: filteredChallenges = challenges.filter((challenge) => {
    if (selectedTab === "All") return true;
    if (selectedTab === "Fitness") return challenge.type === "Fitness";
    if (selectedTab === "Other") return challenge.type === "Other";
    if (selectedTab === "Public") return challenge.is_public;
    if (selectedTab === "Private") return !challenge.is_public;
    if (selectedTab === "Friends") {
      // Placeholder: Add logic for friends' challenges later
      return false;
    }
    return true;
  });
</script>

<div class="challenge-table">
  <div class="tabs">
    {#each tabs as tab}
      <button
        class={selectedTab === tab ? "active" : ""}
        on:click={() => (selectedTab = tab)}
      >
        {tab}
      </button>
    {/each}
  </div>

  <div class="table-wrapper">
    <table>
      <thead>
        <tr>
          <th on:click={() => sortChallenges("title")}>Title</th>
          <th on:click={() => sortChallenges("type")}>Type</th>
          <th on:click={() => sortChallenges("participants_current")}
            >Players</th
          >
          <th on:click={() => sortChallenges("cost")}>Cost</th>
          <th on:click={() => sortChallenges("prize_pool")}>Prize</th>
          <th on:click={() => sortChallenges("scoring_type")}>Scoring</th>
          <th on:click={() => sortChallenges("is_public")}>Access</th>
          <th>Join</th>
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
        {:else if filteredChallenges.length > 0}
          {#each filteredChallenges as challenge, index}
            <tr class={index % 2 === 0 ? "even-row" : "odd-row"}>
              <td data-label="Title">{challenge.title}</td>
              <td data-label="Type">{challenge.type}</td>
              <td data-label="Players"
                >{challenge.participants_current}/{challenge.participants_max}</td
              >
              <td data-label="Cost">${challenge.cost.toFixed(2)}</td>
              <td data-label="Prize">${challenge.prize_pool.toFixed(2)}</td>
              <td data-label="Scoring">{challenge.scoring_type}</td>
              <td data-label="Access"
                >{challenge.is_public ? "Public" : "Private"}</td
              >
              <td data-label="Join">
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
            <td colspan="8" class="no-challenges">No Challenges Available</td>
          </tr>
        {/if}
      </tbody>
    </table>
  </div>

  <div class="footer">
    <input
      type="text"
      bind:value={searchQuery}
      placeholder="Search challenges..."
      class="search-input"
    />
    <button on:click={toggleChallengeCreation} class="create-btn">Create</button
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
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  }

  .tabs {
    display: flex;
    gap: 8px;
    margin-bottom: 1rem;
    flex-wrap: wrap;
  }

  .tabs button {
    padding: 6px 14px;
    background-color: var(--light-gray);
    border: none;
    border-radius: 20px;
    cursor: pointer;
    font-size: 0.85rem;
    transition: all 0.3s ease;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }

  .tabs button.active {
    background-color: var(--tomato);
    color: var(--white);
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  }

  .tabs button:hover:not(.active) {
    background-color: var(--tomato-light);
    transform: translateY(-1px);
  }

  .table-wrapper {
    overflow-x: auto;
    -webkit-overflow-scrolling: touch;
  }

  table {
    width: 100%;
    min-width: 600px;
    border-collapse: collapse;
    font-size: 0.8rem;
  }

  th,
  td {
    padding: 6px 10px;
    text-align: left;
    border-bottom: 1px solid var(--light-gray);
  }

  th {
    background-color: var(--carolina-blue);
    color: var(--charcoal);
    font-size: 0.85rem;
    cursor: pointer;
    transition: background-color 0.3s;
  }

  th:hover {
    background-color: var(--tomato-light);
  }

  tr {
    transition:
      transform 0.2s,
      box-shadow 0.2s;
  }

  tr:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
  }

  .even-row {
    background-color: var(--white);
  }

  .odd-row {
    background-color: var(--light-gray);
  }

  button {
    background-color: var(--tomato);
    color: var(--white);
    border: none;
    padding: 6px 12px;
    border-radius: 4px;
    cursor: pointer;
    font-size: 0.8rem;
    transition:
      transform 0.2s,
      background-color 0.3s;
  }

  button:disabled {
    background-color: var(--gray);
    cursor: not-allowed;
  }

  button:hover:not(:disabled) {
    background-color: var(--tomato-light);
    transform: scale(1.05);
  }

  .error {
    color: var(--tomato);
    text-align: center;
  }

  .no-challenges {
    text-align: center;
    padding: 1rem;
    color: var(--gray);
  }

  .footer {
    display: flex;
    justify-content: space-between;
    margin-top: 1rem;
    gap: 1rem;
  }

  .search-input {
    padding: 6px;
    border: 1px solid var(--light-gray);
    border-radius: 4px;
    font-size: 0.85rem;
    width: 100%;
    max-width: 250px;
    background-color: var(--white);
    color: var(--charcoal);
  }

  .create-btn {
    background-color: var(--tomato);
  }

  .create-btn:hover {
    background-color: var(--tomato-light);
  }
</style>
