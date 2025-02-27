<script>
  import { onMount } from "svelte";
  import { supabase } from "../supabase.js";
  import ChallengeTable from "./ChallengeTable.svelte";

  let allChallenges = [];
  let challenges = []; // This will be the filtered list
  let loading = true;
  let error = null;
  let searchQuery = "";

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

  // Filter challenges based on search query
  $: {
    const query = searchQuery.toLowerCase().trim();
    if (!query) {
      challenges = [...allChallenges];
    } else {
      challenges = allChallenges.filter((challenge) => {
        return (
          challenge.title.toLowerCase().includes(query) ||
          challenge.type.toLowerCase().includes(query) ||
          challenge.cost.toString().includes(query)
        );
      });
    }
  }
</script>

<div class="challenge-lobby">
  <h2>Challenge Lobby</h2>
  <ChallengeTable {challenges} {loading} {error} />
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
</style>
