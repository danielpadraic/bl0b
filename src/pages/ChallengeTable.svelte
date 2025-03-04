<script>
  import { onMount } from "svelte";
  import { user } from "../stores.js";
  import { createEventDispatcher } from "svelte";
  import { navigate } from "svelte-routing";

  export let challenges = [];
  export let loading = false;
  export let error = null;
  export let searchQuery = "";
  export let selectedTab = "All";

  const dispatch = createEventDispatcher();

  let sortColumn = null;
  let sortDirection = "asc";
  let resizing = false;
  let startX, startWidth, targetTh;
  let showCompleted = false;

  const tabs = [
    "All",
    "Fitness",
    "Other",
    "Friends",
    "Public",
    "Private",
    "Completed",
  ];

  // Sorting function (unchanged)
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

  // Resizing functions (unchanged)
  function startResize(event, th) {
    event.preventDefault();
    resizing = true;
    startX = event.pageX;
    startWidth = th.getBoundingClientRect().width;
    targetTh = th;
  }

  function resize(event) {
    if (resizing && targetTh) {
      const width = startWidth + (event.pageX - startX);
      targetTh.style.width = `${Math.max(width, 50)}px`;
    }
  }

  function stopResize() {
    if (resizing) {
      resizing = false;
      targetTh = null;
    }
  }

  onMount(() => {
    window.addEventListener("mousemove", resize);
    window.addEventListener("mouseup", stopResize);
    return () => {
      window.removeEventListener("mousemove", resize);
      window.removeEventListener("mouseup", stopResize);
    };
  });

  function toggleChallengeCreation() {
    dispatch("onCreate");
  }

  function joinChallenge(challengeId) {
    dispatch("onJoin", challengeId);
  }

  // Updated filter logic
  $: filteredChallenges = challenges.filter((challenge) => {
    const now = new Date();
    const thirtyDaysAgo = new Date(now.setDate(now.getDate() - 30));
    const endDate = challenge.end_datetime
      ? new Date(challenge.end_datetime)
      : null;
    const isCompleted = endDate && endDate < new Date();

    // Apply "Completed" filter
    if (showCompleted) {
      if (!isCompleted || (endDate && endDate < thirtyDaysAgo)) {
        return false;
      }
    } else if (isCompleted) {
      return false;
    }

    // Apply other tab filters
    if (selectedTab === "All") return true;
    if (selectedTab === "Fitness") return challenge.type === "Fitness";
    if (selectedTab === "Other") return challenge.type !== "Fitness"; // Updated to include all non-Fitness challenges
    if (selectedTab === "Public") return challenge.is_public;
    if (selectedTab === "Private") return !challenge.is_public;
    if (selectedTab === "Friends") {
      // Placeholder for friends' challenges
      return false;
    }
    if (selectedTab === "Completed") return true; // Handled by showCompleted
    return true;
  });
</script>

<!-- HTML and <style> sections remain unchanged -->
<div class="challenge-table">
  <div class="tabs">
    {#each tabs as tab}
      <button
        class={tab === "Completed"
          ? showCompleted
            ? "active completed-active"
            : ""
          : selectedTab === tab
            ? "active"
            : ""}
        on:click={() => {
          if (tab === "Completed") {
            showCompleted = !showCompleted;
          } else {
            selectedTab = tab;
          }
        }}
      >
        {tab}
      </button>
    {/each}
  </div>

  <div class="table-wrapper">
    <table>
      <thead>
        <tr>
          <th class="title-column" on:click={() => sortChallenges("title")}>
            Title
            <div
              class="resize-handle"
              on:mousedown={(e) => startResize(e, e.target.parentElement)}
            ></div>
          </th>
          <th on:click={() => sortChallenges("type")}>
            Type
            <div
              class="resize-handle"
              on:mousedown={(e) => startResize(e, e.target.parentElement)}
            ></div>
          </th>
          <th on:click={() => sortChallenges("participants_current")}>
            Players
            <div
              class="resize-handle"
              on:mousedown={(e) => startResize(e, e.target.parentElement)}
            ></div>
          </th>
          <th on:click={() => sortChallenges("cost")}>
            Cost
            <div
              class="resize-handle"
              on:mousedown={(e) => startResize(e, e.target.parentElement)}
            ></div>
          </th>
          <th on:click={() => sortChallenges("prize_pool")}>
            Prize
            <div
              class="resize-handle"
              on:mousedown={(e) => startResize(e, e.target.parentElement)}
            ></div>
          </th>
          <th on:click={() => sortChallenges("scoring_type")}>
            Scoring
            <div
              class="resize-handle"
              on:mousedown={(e) => startResize(e, e.target.parentElement)}
            ></div>
          </th>
          <th on:click={() => sortChallenges("is_public")}>
            Access
            <div
              class="resize-handle"
              on:mousedown={(e) => startResize(e, e.target.parentElement)}
            ></div>
          </th>
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
              <td data-label="Title">
                <a
                  href={`/challenge/${challenge.id}`}
                  on:click|preventDefault={() =>
                    navigate(`/challenge/${challenge.id}`)}
                >
                  {challenge.title}
                </a>
              </td>
              <td data-label="Type">{challenge.type}</td>
              <td data-label="Players">
                {challenge.participants_current}/{challenge.participants_max ===
                "Unlimited"
                  ? "∞"
                  : challenge.participants_max}
              </td>
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

<!-- <style> section remains unchanged, included here for completeness -->
<style>
  .challenge-table {
    width: 100%;
    max-width: 1200px;
    margin: 0 auto;
    padding: 1.5rem;
    background-color: var(--background);
    color: var(--text);
    border-radius: 12px;
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
    transform: translateZ(0);
    position: relative;
  }

  .tabs {
    display: flex;
    gap: 10px;
    margin-bottom: 1.5rem;
    flex-wrap: wrap;
    perspective: 500px;
  }

  .tabs button {
    padding: 8px 16px;
    background-color: var(--light-gray);
    border: none;
    border-radius: 20px;
    cursor: pointer;
    font-size: 0.9rem;
    transition: all 0.3s ease;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    transform-style: preserve-3d;
  }

  .tabs button.active {
    background-color: var(--tomato);
    color: var(--white);
    transform: rotateX(10deg) translateZ(10px);
    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.2);
  }

  .tabs button.completed-active {
    background-color: var(--lapis-lazuli);
    color: var(--white);
    transform: rotateX(10deg) translateZ(10px);
    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.2);
  }

  .tabs button:hover:not(.active):not(.completed-active) {
    background-color: var(--tomato-light);
    transform: translateZ(5px) rotateX(5deg);
    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
  }

  .tabs button.completed-active:hover,
  .tabs button.active:hover {
    background-color: var(--tomato-light);
  }

  .table-wrapper {
    overflow-x: auto;
    -webkit-overflow-scrolling: touch;
    background: var(--white);
    border-radius: 8px;
    box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.05);
  }

  table {
    width: 100%;
    table-layout: fixed;
    border-collapse: separate;
    border-spacing: 0;
    font-size: 0.85rem;
    background: var(--white);
    border-radius: 8px;
    overflow: hidden;
  }

  th,
  td {
    padding: 6px 10px;
    text-align: left;
    border: 1px solid var(--light-gray);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    position: relative;
  }

  th {
    background-color: var(--carolina-blue);
    color: var(--charcoal);
    font-size: 0.9rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    position: sticky;
    top: 0;
    z-index: 1;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }

  th.title-column {
    width: 150px;
  }

  th:hover {
    background-color: var(--tomato-light);
    transform: translateZ(2px);
  }

  .resize-handle {
    position: absolute;
    right: 0;
    top: 0;
    width: 6px;
    height: 100%;
    cursor: col-resize;
    background-color: transparent;
    transition: background-color 0.2s;
  }

  .resize-handle:hover,
  .resize-handle:active {
    background-color: var(--tomato);
    opacity: 0.7;
  }

  tr {
    transition: all 0.3s ease;
    transform-style: preserve-3d;
  }

  tr:hover {
    transform: translateY(-3px) translateZ(10px);
    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
    background-color: rgba(255, 255, 255, 0.95);
  }

  .even-row {
    background-color: var(--white);
  }

  .odd-row {
    background-color: var(--light-gray);
  }

  td button {
    background-color: var(--tomato);
    color: var(--white);
    border: none;
    padding: 4px 12px;
    border-radius: 6px;
    cursor: pointer;
    font-size: 0.85rem;
    transition: all 0.3s ease;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    transform-style: preserve-3d;
  }

  td button:disabled {
    background-color: var(--gray);
    cursor: not-allowed;
    box-shadow: none;
  }

  td button:hover:not(:disabled) {
    background-color: var(--tomato-light);
    transform: scale(1.1) translateZ(5px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
  }

  .error {
    color: var(--tomato);
    text-align: center;
    padding: 1rem;
  }

  .no-challenges {
    text-align: center;
    padding: 1.5rem;
    color: var(--gray);
    font-style: italic;
  }

  .footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 1.5rem;
    gap: 1rem;
  }

  .search-input {
    padding: 8px 12px;
    border: 1px solid var(--light-gray);
    border-radius: 6px;
    font-size: 0.9rem;
    width: 100%;
    max-width: 300px;
    background-color: var(--white);
    color: var(--charcoal);
    box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.05);
    transition: all 0.3s ease;
  }

  .search-input:focus {
    border-color: var(--tomato);
    box-shadow: 0 0 8px rgba(242, 100, 64, 0.3);
    outline: none;
  }

  .create-btn {
    background-color: var(--tomato);
    padding: 8px 18px;
    border-radius: 6px;
    font-size: 0.9rem;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    transition: all 0.3s ease;
  }

  .create-btn:hover {
    background-color: var(--tomato-light);
    transform: translateY(-2px) translateZ(5px);
    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
  }
</style>
