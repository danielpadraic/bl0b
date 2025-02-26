<script>
  import { supabase } from "../supabase.js";
  import { user } from "../stores/user.js";
  import { onMount } from "svelte";
  import BottomNav from "../components/BottomNav.svelte";

  let userChallenges = [];
  let loading = true;

  onMount(async () => {
    const userId = supabase.auth.user().id;
    const { data, error } = await supabase
      .from("challenge_participants")
      .select("challenge_id")
      .eq("user_id", userId);
    if (!error) {
      const challengeIds = data.map((d) => d.challenge_id);
      const { data: challenges, error: err } = await supabase
        .from("challenges")
        .select("*")
        .in("id", challengeIds);
      if (!err) userChallenges = challenges;
    }
    loading = false;
  });

  async function getLeaderboard(challengeId) {
    const { data } = await supabase
      .from("user_challenge_logs")
      .select("user_id, sum(metric_value) as total")
      .eq("challenge_id", challengeId)
      .groupBy("user_id")
      .order("total", { ascending: false })
      .limit(10);
    return data;
  }
</script>

<div class="leaderboards">
  <h1>Leaderboards</h1>
  {#if loading}
    <p>Loading...</p>
  {:else}
    {#each userChallenges as challenge}
      <div class="leaderboard">
        <h2>{challenge.name}</h2>
        {#await getLeaderboard(challenge.id)}
          <p>Loading leaderboard...</p>
        {:then leaderboard}
          <ol>
            {#each leaderboard as entry}
              <li>{entry.user_id}: {entry.total}</li>
            {/each}
          </ol>
        {/await}
      </div>
    {/each}
  {/if}
</div>
<BottomNav activeTab="leaderboards" />

<style>
  .leaderboards {
    padding: 20px;
    padding-bottom: 60px;
  }
  .leaderboard {
    border: 1px solid var(--charcoal);
    padding: 10px;
    margin-bottom: 10px;
  }
  .leaderboard:hover {
    border-color: var(--carolina-blue);
  }
</style>
