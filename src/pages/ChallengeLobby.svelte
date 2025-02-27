<script>
  import { onMount } from "svelte";
  import { navigate } from "svelte-routing";
  import { supabase } from "../supabase.js";
  import { user, showChallengeCreation } from "../stores.js";
  import ChallengeTable from "./ChallengeTable.svelte";

  let allChallenges = [];
  let challenges = [];
  let loading = true;
  let error = null;
  let searchQuery = "";
  let showAuthPrompt = false;
  let promptAction = "";

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
          "id, title, type, participants_max, buy_in_cost, additional_prize_money, prize_type, prize_amount, number_of_winners, scoring_type, is_private, participants_current"
        )
        .order("created_at", { ascending: false });

      if (fetchError) throw fetchError;

      console.log("Fetched challenges:", data);

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
      }));
      challenges = [...allChallenges];
      console.log("Mapped challenges:", challenges);
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
    console.log("Filtering with query:", query);
    if (!query) {
      challenges = [...allChallenges];
    } else {
      challenges = allChallenges.filter((challenge) => {
        const matches =
          challenge.title.toLowerCase().includes(query) ||
          challenge.type.toLowerCase().includes(query) ||
          challenge.cost.toString().includes(query);
        console.log("Challenge:", challenge.title, "Matches:", matches);
        return matches;
      });
    }
    console.log("Filtered challenges:", challenges);
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
      alert("Successfully joined the challenge!");
      await fetchChallenges();
    } catch (err) {
      console.error("Error joining challenge:", err);
      alert("Failed to join challenge: " + err.message);
    }
  }

  function closePrompt(event) {
    console.log("Closing prompt via", event.type);
    if (
      event.type === "click" ||
      (event.type === "keydown" && event.key === "Escape")
    ) {
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

  // Event handlers for ChallengeTable
  function handleCreate() {
    handleInteraction("create");
  }

  function handleJoin(event) {
    const challengeId = event.detail;
    handleInteraction("join", challengeId);
  }
</script>

<div class="challenge-lobby">
  <div class="content" class:blur={showAuthPrompt}>
    <h2>Challenge Lobby</h2>

    <!-- Display challenges -->
    <ChallengeTable
      {challenges}
      {loading}
      {error}
      bind:searchQuery
      on:onJoin={handleJoin}
      on:onCreate={handleCreate}
    />

    {#if !$user}
      <div class="create-account-link">
        <p>Not a member yet?</p>
        <button on:click={goToSignUp}>Create an Account</button>
      </div>
    {/if}
  </div>

  <!-- Prompt for unauthenticated users -->
  {#if showAuthPrompt}
    <div
      class="auth-prompt-overlay"
      on:click={closePrompt}
      on:keydown={closePrompt}
    >
      <div class="auth-prompt">
        <p>
          Please sign up or log in to {promptAction === "create"
            ? "create a challenge"
            : "join a challenge"}.
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
    color: var(--text);
    position: relative;
    min-height: 100vh;
  }

  .content {
    position: relative;
    z-index: 1;
  }

  .blur {
    filter: blur(5px);
  }

  h2 {
    margin: 0 0 1rem 0;
    font-size: clamp(1rem, 4vw, 2rem);
    text-align: left;
  }

  .auth-prompt-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 1000;
  }

  .auth-prompt {
    background: var(--white);
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
    text-align: center;
    max-width: 400px;
    width: 90%;
    z-index: 1001;
  }

  .prompt-buttons {
    margin-top: 15px;
    display: flex;
    justify-content: center;
    gap: 10px;
  }

  .create-account-link {
    margin-top: 20px;
    text-align: center;
  }

  button {
    margin: 5px;
    padding: 5px 10px;
    background-color: var(--tomato);
    color: var(--white);
    border: none;
    border-radius: 4px;
    cursor: pointer;
  }

  button:hover {
    background-color: var(--tomato-light);
  }
</style>
