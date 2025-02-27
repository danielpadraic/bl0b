<script>
  import { onMount } from "svelte";
  import { supabase } from "../supabase.js";
  import ChallengeTable from "./ChallengeTable.svelte";

  let challenges = [];
  let loading = true;
  let error = null;

  onMount(async () => {
    await fetchChallenges();
  });

  async function fetchChallenges() {
    try {
      loading = true;
      const { data, error: fetchError } = await supabase
        .from("challenges")
        .select(
          "title, type, max_participants, buy_in_cost, additional_prize_money, prize_type, prize_amount, number_of_winners, scoring_type, is_private, participants_current"
        )
        .order("created_at", { ascending: false });

      if (fetchError) throw fetchError;

      challenges = data.map((challenge) => ({
        title: challenge.title,
        type: challenge.type,
        participants_max: challenge.max_participants || "Unlimited", // Handle null as "Unlimited"
        cost: challenge.buy_in_cost || 0,
        prize_pool:
          (challenge.buy_in_cost || 0) +
          (challenge.additional_prize_money || 0), // Placeholder calculation
        scoring_type: challenge.scoring_type || "None",
        is_public: !challenge.is_private, // Inverse of is_private
        participants_current: challenge.participants_current || 0,
      }));
      error = null;
    } catch (err) {
      error = err.message;
      console.error("Error fetching challenges:", err);
    } finally {
      loading = false;
    }
  }
</script>

<div class="challenge-lobby">
  <ChallengeTable {challenges} {loading} {error} />
</div>

<style>
  .challenge-lobby {
    padding: 1rem;
    background-color: var(--background);
    color: var(--text);
  }
</style>
