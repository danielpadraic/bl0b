<script>
  import { onMount } from "svelte";
  import { navigate } from "svelte-routing";
  import { supabase } from "../supabase.js"; // Correct path from src/pages/
  import { user, showChallengeCreation } from "../stores.js"; // Correct path from src/pages/
  import ChallengeTable from "./ChallengeTable.svelte";

  let allChallenges = []; // Unfiltered list
  let challenges = []; // Filtered list passed to table
  let loading = true;
  let error = null;
  let searchQuery = "";
  let showAuthPrompt = false; // Controls the sign-up/login prompt

  onMount(async () => {
    await fetchChallenges();
  });

  async function fetchChallenges() {
    try {
      loading = true;
      const { data, error: fetchError } = await supabase
        .from("challenges")
        .select(
          "title, type, participants_max, buy_in_cost, additional_prize_money, prize_type, prize_amount, number_of_winners, scoring_type, is_private, participants_current"
        )
        .order("created_at", { ascending: false });

      if (fetchError) throw fetchError;

      allChallenges = data.map((challenge) => ({
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
      challenges = [...allChallenges]; // Initialize with all challenges
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

  // Reactively update challenges when searchQuery changes
  $: searchQuery, filterChallenges();

  // Handle interactions (create, join, view)
  function handleInteraction(action) {
    if (!$user) {
      showAuthPrompt = true;
    } else {
      if (action === "create") {
        $showChallengeCreation = true;
      } else if (action === "join") {
        alert("Join challenge (add your logic here)");
      } else if (action === "view") {
        alert("View challenge (add your logic here)");
      }
    }
  }

  // Close the prompt
  function closePrompt() {
    showAuthPrompt = false;
  }

  // Navigate to sign-up or login pages
  function goToSignUp() {
    navigate("/signup");
  }

  function goToLogin() {
    navigate("/login");
  }
</script>

<div class="challenge-lobby">
  <h2>Challenge Lobby</h2>

  <!-- Prompt for unauthenticated users -->
  {#if showAuthPrompt}
    <div class="auth-prompt">
      <p>Please sign up or log in to {handleInteraction.action} challenges.</p>
      <button on:click={goToSignUp}>Sign Up</button>
      <button on:click={goToLogin}>Log In</button>
      <button on:click={closePrompt}>Close</button>
    </div>
  {/if}

  <!-- Display challenges -->
  <ChallengeTable {challenges} {loading} {error} bind:searchQuery />

  <!-- Create Challenge button -->
  {#if $user}
    <button on:click={() => handleInteraction("create")}
      >Create Challenge</button
    >
  {:else}
    <button on:click={() => handleInteraction("create")}
      >Create Challenge (Login Required)</button
    >
    <div class="create-account-link">
      <p>Not a member yet?</p>
      <button on:click={goToSignUp}>Create an Account</button>
    </div>
  {/if}
</div>

<style>
  .challenge-lobby {
    padding: 1rem;
    background-color: var(--background);
    color: var(--text);
  }

  h2 {
    margin: 0 0 1rem 0;
    font-size: clamp(1rem, 4vw, 2rem);
    text-align: left;
  }

  .auth-prompt {
    border: 1px solid var(--light-gray);
    padding: 10px;
    margin: 10px 0;
    background: #f9f9f9;
  }

  .create-account-link {
    margin-top: 20px;
    text-align: center;
  }

  button {
    margin: 0 5px;
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
