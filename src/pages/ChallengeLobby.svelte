<script>
  import { onMount } from "svelte";
  import { navigate } from "svelte-routing";
  import { supabase } from "../supabase.js";
  import { user, showChallengeCreation } from "../stores.js";
  import ChallengeTable from "./ChallengeTable.svelte";
  import NewsFeed from "../components/NewsFeed.svelte";

  let allChallenges = [];
  let challenges = [];
  let loading = true;
  let error = null;
  let searchQuery = "";
  let showAuthPrompt = false;
  let promptAction = "";
  let selectedTab = "All";

  onMount(async () => {
    console.log("ChallengeLobby mounted, user:", $user);
    await fetchChallenges();
  });

  async function fetchChallenges() {
    try {
      loading = true;
      const { data, error: fetchError } = await supabase
        .from("challenges")
        .select(
          "id, title, type, participants_max, buy_in_cost, additional_prize_money, prize_type, prize_amount, number_of_winners, scoring_type, is_private, participants_current, start_datetime, end_datetime"
        )
        .order("created_at", { ascending: false });

      if (fetchError) throw fetchError;

      allChallenges = data.map((challenge) => ({
        id: challenge.id,
        title: challenge.title,
        type: challenge.type,
        participants_max:
          challenge.participants_max === 0
            ? "Unlimited"
            : challenge.participants_max,
        participants_current: challenge.participants_current || 0,
        cost: challenge.buy_in_cost || 0,
        prize_pool:
          (challenge.buy_in_cost || 0) * (challenge.participants_current || 0),
        scoring_type: challenge.scoring_type || "None",
        is_public: !challenge.is_private,
        start_datetime: challenge.start_datetime,
        end_datetime: challenge.end_datetime,
      }));
      challenges = [...allChallenges];
      error = null;
    } catch (err) {
      error = err.message;
      console.error("Error fetching challenges:", err);
    } finally {
      loading = false;
    }
  }

  function filterChallenges() {
    const query = searchQuery.toLowerCase().trim();
    if (!query) {
      challenges = [...allChallenges];
    } else {
      challenges = allChallenges.filter(
        (challenge) =>
          challenge.title.toLowerCase().includes(query) ||
          challenge.type.toLowerCase().includes(query) ||
          challenge.cost.toString().includes(query)
      );
    }
  }

  $: searchQuery, filterChallenges();

  function handleInteraction(action, challengeId = null) {
    console.log(
      "handleInteraction called with action:",
      action,
      "challengeId:",
      challengeId,
      "user:",
      $user
    );
    if (!$user) {
      console.log("User not authenticated, showing prompt");
      showAuthPrompt = true;
      promptAction = action;
    } else {
      console.log("User authenticated, proceeding with action:", action);
      if (action === "create") {
        $showChallengeCreation = true;
        setTimeout(fetchChallenges, 1000); // Refresh after creation
      } else if (action === "join" && challengeId) {
        joinChallenge(challengeId);
      }
    }
    console.log("showAuthPrompt set to:", showAuthPrompt);
  }

  async function joinChallenge(challengeId) {
    try {
      const { error } = await supabase
        .from("challenge_participants")
        .insert([{ challenge_id: challengeId, user_id: $user.id }]);
      if (error) throw error;
      alert("Joined challenge!");
      await fetchChallenges();
    } catch (err) {
      alert("Error joining: " + err.message);
    }
  }

  function closePrompt(event) {
    if (event.type === "click" || event.key === "Escape") {
      showAuthPrompt = false;
      promptAction = "";
    }
  }

  function goToSignUp() {
    navigate("/signup");
    closePrompt({ type: "click" });
  }

  function goToLogin() {
    navigate("/login");
    closePrompt({ type: "click" });
  }

  function handleCreate() {
    handleInteraction("create");
  }

  function handleJoin(event) {
    handleInteraction("join", event.detail);
  }
</script>

<div class="challenge-lobby">
  <div class="layout">
    <div class="news-feed-container">
      <NewsFeed />
    </div>
    <div class="table-container">
      <ChallengeTable
        {challenges}
        {loading}
        {error}
        bind:searchQuery
        bind:selectedTab
        on:onJoin={handleJoin}
        on:onCreate={handleCreate}
      />
    </div>
  </div>

  {#if !$user}
    <div class="create-account-link">
      <p>Not a member?</p>
      <button on:click={goToSignUp}>Sign Up</button>
    </div>
  {/if}

  {#if showAuthPrompt}
    <div
      class="auth-prompt-overlay"
      on:click={closePrompt}
      on:keydown={closePrompt}
    >
      <div class="auth-prompt">
        <p>
          Please sign up or log in to {promptAction === "create"
            ? "create"
            : "join"} a challenge.
        </p>
        <div class="prompt-buttons">
          <button on:click={goToSignUp}>Sign Up</button>
          <button on:click={goToLogin}>Log In</button>
          <button on:click={closePrompt}>Close</button>
        </div>
      </div>
    </div>
  {/if}
</div>

<style>
  .challenge-lobby {
    padding: 1rem;
    background-color: var(--background);
    min-height: 100vh;
  }

  .layout {
    display: flex;
    max-width: 1200px;
    margin: 0 auto;
    gap: 1rem;
  }

  .news-feed-container {
    width: 25%;
  }

  .table-container {
    flex: 1;
  }

  @media (max-width: 768px) {
    .layout {
      flex-direction: column;
    }
    .news-feed-container {
      display: none;
    }
  }

  .create-account-link {
    text-align: center;
    margin-top: 1rem;
  }
</style>
