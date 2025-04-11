<script>
  import { onMount } from "svelte";
  import { navigate } from "svelte-routing";
  import { user } from "../stores.js";
  import { supabase } from "../supabase.js";
  import ChallengeCard from "../components/ChallengeCard.svelte";
  import BottomNav from "../components/BottomNav.svelte";
  import LoadingSpinner from "../components/LoadingSpinner.svelte";

  // Search and filter state
  let searchQuery = "";
  let filterCategory = "all";
  let challenges = [];
  let filteredChallenges = [];
  let loading = true;
  let hasSearched = false;
  let notificationCount = 0;

  // Categories for filtering
  const categories = [
    { id: "all", label: "All" },
    { id: "fitness", label: "Fitness" },
    { id: "running", label: "Running" },
    { id: "cycling", label: "Cycling" },
    { id: "weight", label: "Weight Loss" },
    { id: "nutrition", label: "Nutrition" },
    { id: "other", label: "Other" },
  ];

  onMount(async () => {
    await fetchChallenges();
    if ($user) {
      await fetchNotificationCount();
    }
    loading = false;
  });

  async function fetchChallenges() {
    try {
      let query = supabase.from("challenges").select(`
            id, 
            title, 
            type, 
            cover_media, 
            participants_max, 
            participants_current,
            prize_pool,
            buy_in_cost,
            start_datetime,
            end_datetime,
            is_private,
            profiles!challenges_creator_id_fkey(username, profile_photo_url)
          `);

      if (!$user) {
        // Only show public challenges for non-logged in users
        query = query.eq("is_private", false);
      }

      const { data, error } = await query;

      if (error) throw error;

      // Process challenges
      challenges = data.map((challenge) => {
        // Get time status
        const now = new Date();
        const startDate = challenge.start_datetime
          ? new Date(challenge.start_datetime)
          : null;
        const endDate = challenge.end_datetime
          ? new Date(challenge.end_datetime)
          : null;

        let status = "unknown";
        if (startDate && endDate) {
          if (now < startDate) status = "upcoming";
          else if (now >= startDate && now < endDate) status = "active";
          else status = "completed";
        }

        return {
          ...challenge,
          status,
          creatorUsername: challenge.profiles?.username || "Unknown",
          creatorPhoto: challenge.profiles?.profile_photo_url || null,
        };
      });

      // Set initial filtered challenges
      filteredChallenges = [...challenges];
    } catch (err) {
      console.error("Error fetching challenges:", err);
      challenges = [];
      filteredChallenges = [];
    }
  }

  async function fetchNotificationCount() {
    if (!$user) return;

    try {
      const { count, error } = await supabase
        .from("notifications")
        .select("id", { count: "exact" })
        .eq("user_id", $user.id)
        .eq("read", false);

      if (!error) {
        notificationCount = count || 0;
      }
    } catch (err) {
      console.error("Error fetching notifications:", err);
    }
  }

  function handleSearch() {
    hasSearched = true;
    filterChallenges();
  }

  function filterChallenges() {
    filteredChallenges = challenges.filter((challenge) => {
      // Apply text search
      const matchesQuery = searchQuery
        ? challenge.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
          challenge.type.toLowerCase().includes(searchQuery.toLowerCase())
        : true;

      // Apply category filter
      const matchesCategory =
        filterCategory === "all"
          ? true
          : challenge.type.toLowerCase().includes(filterCategory.toLowerCase());

      return matchesQuery && matchesCategory;
    });
  }

  // Reactive statement to update filtering when category changes
  $: if (filterCategory) {
    filterChallenges();
  }

  function handleChallengeClick(challengeId) {
    navigate(`/challenge/${challengeId}`);
  }
</script>

<div class="discover-page">
  <!-- Search section -->
  <div class="search-section">
    <div class="search-bar-container">
      <input
        type="text"
        bind:value={searchQuery}
        placeholder="Search challenges..."
        class="search-input"
      />
      <button
        class="search-button"
        on:click={handleSearch}
        aria-label="Search challenges"
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="20"
          height="20"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2.5"
          stroke-linecap="round"
          stroke-linejoin="round"
        >
          <circle cx="11" cy="11" r="8"></circle>
          <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
        </svg>
      </button>
    </div>

    <!-- Category filter -->
    <div class="category-filter">
      <div class="filter-scroll">
        {#each categories as category}
          <button
            class="filter-pill"
            class:active={filterCategory === category.id}
            on:click={() => (filterCategory = category.id)}
          >
            {category.label}
          </button>
        {/each}
      </div>
    </div>
  </div>

  <!-- Results section -->
  <div class="results-section">
    {#if loading}
      <LoadingSpinner />
    {:else if filteredChallenges.length === 0}
      <div class="empty-results">
        {#if hasSearched}
          <p>No challenges found for "{searchQuery}"</p>
          <button
            class="reset-button"
            on:click={() => {
              searchQuery = "";
              filterCategory = "all";
              filteredChallenges = [...challenges];
              hasSearched = false;
            }}>Reset Search</button
          >
        {:else}
          <p>Start by searching for challenges</p>
        {/if}
      </div>
    {:else}
      <div class="challenge-grid">
        {#each filteredChallenges as challenge}
          <div class="challenge-card-wrapper">
            <ChallengeCard
              {challenge}
              on:click={() => handleChallengeClick(challenge.id)}
            />
          </div>
        {/each}
      </div>
    {/if}
  </div>

  <!-- Bottom Navigation -->
  <BottomNav activeTab="discover" {notificationCount} />
</div>

<style>
  .discover-page {
    padding-top: 60px; /* Space for fixed header */
    padding-bottom: 60px; /* Space for bottom nav */
    min-height: 100vh;
    background-color: var(--background);
  }

  .search-section {
    position: sticky;
    top: 60px; /* Below app header */
    background-color: white;
    z-index: 10;
    padding: 16px 16px 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  }

  .search-bar-container {
    position: relative;
    margin-bottom: 16px;
  }

  .search-input {
    width: 100%;
    padding: 12px 48px 12px 16px;
    border: 1px solid var(--light-gray);
    border-radius: 8px;
    font-size: 16px;
    background-color: var(--light-gray);
    color: var(--charcoal);
  }

  .search-input:focus {
    outline: none;
    border-color: var(--tomato);
    background-color: white;
  }

  .search-button {
    position: absolute;
    right: 8px;
    top: 50%;
    transform: translateY(-50%);
    background-color: var(--tomato);
    color: white;
    border: none;
    width: 36px;
    height: 36px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
  }

  .category-filter {
    overflow-x: hidden;
    width: 100%;
    margin-bottom: 8px;
  }

  .filter-scroll {
    display: flex;
    overflow-x: auto;
    -webkit-overflow-scrolling: touch;
    scrollbar-width: none; /* Firefox */
    gap: 8px;
    padding-bottom: 4px;
  }

  /* Hide scrollbar for Chrome/Safari */
  .filter-scroll::-webkit-scrollbar {
    display: none;
  }

  .filter-pill {
    flex: 0 0 auto;
    padding: 8px 16px;
    background-color: var(--light-gray);
    border: none;
    border-radius: 20px;
    font-size: 14px;
    font-weight: 500;
    color: var(--charcoal);
    cursor: pointer;
    white-space: nowrap;
  }

  .filter-pill.active {
    background-color: var(--tomato);
    color: white;
  }

  .results-section {
    padding: 16px;
  }

  .challenge-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
    gap: 16px;
  }

  .challenge-card-wrapper {
    height: 100%;
  }

  .empty-results {
    padding: 32px 16px;
    text-align: center;
  }

  .empty-results p {
    color: var(--gray);
    margin-bottom: 16px;
    font-size: 16px;
  }

  .reset-button {
    background-color: var(--tomato);
    color: white;
    border: none;
    padding: 8px 16px;
    border-radius: 8px;
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
  }

  /* For larger screens */
  @media (min-width: 768px) {
    .challenge-grid {
      grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
    }
  }
</style>
