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

  const defaultColumns = [
    { key: "title", label: "Title", class: "title-column" },
    { key: "type", label: "Type" },
    { key: "participants_current", label: "Players" },
    { key: "cost", label: "Cost" },
    { key: "prize_pool", label: "Prize" },
    { key: "scoring_type", label: "Scoring" },
    { key: "is_public", label: "Access" },
    { key: "join", label: "Join" },
  ];
  let columns = [...defaultColumns];

  let dragging = false;
  let draggedCol = null;
  let longPressTimer = null;
  const LONG_PRESS_DELAY = 300;

  const tabs = [
    "All",
    "Fitness",
    "Other",
    "Friends",
    "Public",
    "Private",
    "Completed",
  ];

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

  function startResize(event, th) {
    event.preventDefault();
    event.stopPropagation();
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

  function startDrag(event, colKey) {
    event.preventDefault();
    longPressTimer = setTimeout(() => {
      dragging = true;
      draggedCol = colKey;
      document.body.style.cursor = "grabbing";
    }, LONG_PRESS_DELAY);
  }

  function onDrag(event) {
    if (!dragging || !draggedCol) return;

    const thElements = Array.from(event.currentTarget.children);
    const draggedIndex = columns.findIndex((col) => col.key === draggedCol);
    const mouseX = event.pageX;
    let targetIndex = draggedIndex;

    thElements.forEach((th, index) => {
      if (index === draggedIndex) return;
      const rect = th.getBoundingClientRect();
      if (mouseX >= rect.left && mouseX <= rect.right) {
        targetIndex = index;
      }
    });

    if (targetIndex !== draggedIndex) {
      const newColumns = [...columns];
      const [movedCol] = newColumns.splice(draggedIndex, 1);
      newColumns.splice(targetIndex, 0, movedCol);
      columns = newColumns;
    }
  }

  function stopDrag() {
    clearTimeout(longPressTimer);
    if (dragging) {
      dragging = false;
      draggedCol = null;
      document.body.style.cursor = "default";
    }
  }

  function resetColumns() {
    columns = [...defaultColumns];
  }

  onMount(() => {
    window.addEventListener("mousemove", resize);
    window.addEventListener("mouseup", stopResize);
    window.addEventListener("mouseup", stopDrag);
    return () => {
      window.removeEventListener("mousemove", resize);
      window.removeEventListener("mouseup", stopResize);
      window.removeEventListener("mouseup", stopDrag);
    };
  });

  function toggleChallengeCreation() {
    dispatch("onCreate");
  }

  function joinChallenge(challengeId) {
    dispatch("onJoin", challengeId);
  }

  $: filteredChallenges = challenges.filter((challenge) => {
    const now = new Date();
    const thirtyDaysAgo = new Date(now.setDate(now.getDate() - 30));
    const endDate = challenge.end_datetime
      ? new Date(challenge.end_datetime)
      : null;
    const isCompleted = endDate && endDate < new Date();

    if (showCompleted) {
      if (!isCompleted || (endDate && endDate < thirtyDaysAgo)) {
        return false;
      }
    } else if (isCompleted) {
      return false;
    }

    if (selectedTab === "All") return true;
    if (selectedTab === "Fitness") return challenge.type === "Fitness";
    if (selectedTab === "Other") return challenge.type !== "Fitness";
    if (selectedTab === "Public") return challenge.is_public;
    if (selectedTab === "Private") return !challenge.is_public;
    if (selectedTab === "Friends") {
      return false;
    }
    if (selectedTab === "Completed") return true;
    return true;
  });
</script>

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
        <tr on:mousemove={onDrag}>
          {#each columns as column}
            <th
              class="{column.class || ''} {dragging && draggedCol === column.key
                ? 'dragging'
                : ''}"
              on:mousedown={(e) => startDrag(e, column.key)}
              on:click={() =>
                column.key !== "join" && sortChallenges(column.key)}
            >
              <span class="header-content">{column.label}</span>
              {#if column.key !== "join"}
                <div
                  class="resize-handle"
                  on:mousedown={(e) => startResize(e, e.target.parentElement)}
                ></div>
              {/if}
            </th>
          {/each}
        </tr>
      </thead>
      <tbody>
        {#if loading}
          <tr>
            <td colspan={columns.length}>Loading challenges...</td>
          </tr>
        {:else if error}
          <tr>
            <td colspan={columns.length}>Error: {error}</td>
          </tr>
        {:else if filteredChallenges.length > 0}
          {#each filteredChallenges as challenge, index}
            <tr class={index % 2 === 0 ? "even-row" : "odd-row"}>
              {#each columns as column}
                <td
                  class={dragging && draggedCol === column.key
                    ? "dragging"
                    : ""}
                  data-label={column.label}
                >
                  {#if column.key === "title"}
                    <a
                      href={`/challenge/${challenge.id}`}
                      on:click|preventDefault={() =>
                        navigate(`/challenge/${challenge.id}`)}
                    >
                      {challenge.title}
                    </a>
                  {:else if column.key === "type"}
                    {challenge.type}
                  {:else if column.key === "participants_current"}
                    {challenge.participants_current}/{challenge.participants_max ===
                    "Unlimited"
                      ? "∞"
                      : challenge.participants_max}
                  {:else if column.key === "cost"}
                    ${challenge.cost.toFixed(2)}
                  {:else if column.key === "prize_pool"}
                    ${challenge.prize_pool.toFixed(2)}
                  {:else if column.key === "scoring_type"}
                    {challenge.scoring_type}
                  {:else if column.key === "is_public"}
                    {challenge.is_public ? "Public" : "Private"}
                  {:else if column.key === "join"}
                    <button
                      on:click={() => joinChallenge(challenge.id)}
                      disabled={challenge.participants_max !== "Unlimited" &&
                        challenge.participants_current >=
                          challenge.participants_max}
                    >
                      Join
                    </button>
                  {/if}
                </td>
              {/each}
            </tr>
          {/each}
        {:else}
          <tr>
            <td colspan={columns.length}>No Challenges Available</td>
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
    <div class="footer-buttons">
      <button on:click={toggleChallengeCreation} class="create-btn"
        >Create</button
      >
      <button on:click={resetColumns} class="reset-btn">Reset</button>
    </div>
  </div>
</div>

<style>
  .challenge-table {
    width: 100%;
    max-width: 1200px;
    margin: 0 auto;
    padding: 1.5rem;
    background-color: var(--background);
    color: var(--text);
    border-radius: 12px;
    box-shadow: 0 12px 36px rgba(0, 0, 0, 0.2); /* Deeper shadow for 3D */
    transform: perspective(1000px) translateZ(10px); /* Base 3D lift */
    position: relative;
    transition: transform 0.3s ease;
  }

  .challenge-table:hover {
    transform: perspective(1000px) translateZ(20px); /* Slight lift on hover */
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

  .table-wrapper {
    overflow-x: auto;
    -webkit-overflow-scrolling: touch;
    background: var(--white);
    border-radius: 10px;
    box-shadow:
      inset 0 4px 8px rgba(0, 0, 0, 0.1),
      /* Inner depth */ 0 6px 12px rgba(0, 0, 0, 0.15); /* Outer shadow */
    transform: perspective(800px) rotateX(2deg); /* Slight 3D tilt */
    transition: transform 0.3s ease;
  }

  table {
    width: 100%;
    table-layout: fixed;
    border-collapse: separate;
    border-spacing: 0;
    font-size: 0.85rem;
    background: var(--white);
    border-radius: 10px;
    overflow: hidden;
    transform-style: preserve-3d;
  }

  th,
  td {
    padding: 4px 10px; /* Reduced vertical padding for thinner rows */
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
    cursor: grab;
    transition: all 0.3s ease;
    position: sticky;
    top: 0;
    z-index: 1;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15); /* Deeper shadow */
    user-select: none;
    padding-right: 16px;
    transform: perspective(600px) translateZ(5px); /* 3D lift for headers */
  }

  th:active:not(.dragging) {
    cursor: grab;
  }

  th.dragging {
    transform: perspective(600px) translateY(-10px) translateZ(20px); /* Enhanced lift */
    box-shadow: 0 12px 24px rgba(0, 0, 0, 0.35); /* Deeper shadow */
    background-color: var(--tomato-light);
    opacity: 0.9;
    z-index: 2;
    transition:
      transform 0.2s ease,
      box-shadow 0.2s ease;
  }

  th.title-column {
    width: 150px;
  }

  th:hover:not(.dragging) {
    background-color: var(--tomato-light);
    transform: perspective(600px) translateZ(10px); /* More pronounced hover */
  }

  .header-content {
    display: inline-block;
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

  td.dragging {
    transform: perspective(600px) translateY(-10px) translateZ(20px); /* Sync with header */
    box-shadow: 0 12px 24px rgba(0, 0, 0, 0.25); /* Deeper shadow */
    background-color: rgba(245, 138, 108, 0.1);
    opacity: 0.9;
    transition:
      transform 0.2s ease,
      box-shadow 0.2s ease;
  }

  tr {
    transition: all 0.3s ease;
    transform-style: preserve-3d;
  }

  tr:hover:not(.dragging) {
    transform: perspective(600px) translateY(-5px) translateZ(15px); /* Enhanced 3D hover */
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2); /* Deeper shadow */
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
    padding: 3px 10px; /* Adjusted for thinner rows */
    border-radius: 6px;
    cursor: pointer;
    font-size: 0.85rem;
    transition: all 0.3s ease;
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15); /* Slightly deeper shadow */
    transform-style: preserve-3d;
  }

  td button:disabled {
    background-color: var(--gray);
    cursor: not-allowed;
    box-shadow: none;
  }

  td button:hover:not(:disabled) {
    background-color: var(--tomato-light);
    transform: scale(1.1) translateZ(8px); /* More 3D pop */
    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.2);
  }

  .error {
    color: var(--tomato);
    text-align: center;
    padding: 1rem;
  }

  .no-challenges {
    text-align: center;
    padding: 1rem; /* Slightly reduced for thinner look */
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

  .footer-buttons {
    display: flex;
    gap: 8px;
  }

  .search-input {
    padding: 6px 12px; /* Slightly thinner */
    border: 1px solid var(--light-gray);
    border-radius: 6px;
    font-size: 0.9rem;
    width: 100%;
    max-width: 300px;
    background-color: var(--white);
    color: var(--charcoal);
    box-shadow: inset 0 2px 6px rgba(0, 0, 0, 0.1); /* Deeper inset */
    transition: all 0.3s ease;
    transform: perspective(600px) translateZ(2px); /* Subtle 3D */
  }

  .search-input:focus {
    border-color: var(--tomato);
    box-shadow: 0 0 10px rgba(242, 100, 64, 0.4); /* More pronounced glow */
    transform: perspective(600px) translateZ(5px);
    outline: none;
  }

  .create-btn {
    background-color: var(--tomato);
    padding: 6px 16px; /* Slightly thinner */
    border-radius: 6px;
    font-size: 0.9rem;
    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15); /* Deeper shadow */
    transition: all 0.3s ease;
    transform: perspective(600px) translateZ(5px);
  }

  .create-btn:hover {
    background-color: var(--tomato-light);
    transform: perspective(600px) translateY(-3px) translateZ(15px); /* More 3D lift */
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
  }

  .reset-btn {
    background-color: var(--carolina-blue);
    color: var(--charcoal);
    padding: 6px 16px; /* Slightly thinner */
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-size: 0.9rem;
    transition: all 0.3s ease;
    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15); /* Deeper shadow */
    transform: perspective(600px) translateZ(5px);
  }

  .reset-btn:hover {
    background-color: var(--tomato-light);
    color: var(--white);
    transform: perspective(600px) translateY(-3px) translateZ(15px); /* More 3D lift */
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
  }
</style>
