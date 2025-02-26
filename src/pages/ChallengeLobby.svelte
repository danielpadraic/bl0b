<script>
  import { supabase } from "../supabase.js";
  import { onMount } from "svelte";
  import BottomNav from "../components/BottomNav.svelte";

  let challenges = [];
  let loading = true;

  onMount(async () => {
    const { data, error } = await supabase
      .from("challenges")
      .select("*")
      .eq("type", "public");
    if (!error) challenges = data;
    loading = false;
  });
</script>

<div class="challenge-lobby">
  <h1>Challenge Lobby</h1>
  {#if loading}
    <p>Loading...</p>
  {:else}
    {#each challenges as challenge}
      <div class="challenge-card">
        <h2>{challenge.name}</h2>
        <p>{challenge.description}</p>
        {#if challenge.media_url}
          <video src={challenge.media_url} controls width="100%">
            <track
              kind="captions"
              label="English"
              srclang="en"
              src="/captions.vtt"
              default
            />
          </video>
        {/if}
      </div>
    {/each}
  {/if}
</div>
<BottomNav activeTab="home" />

<style>
  .challenge-lobby {
    padding: 20px;
    padding-bottom: 60px; /* Space for bottom nav */
  }
  .challenge-card {
    border: 1px solid var(--charcoal);
    padding: 10px;
    margin-bottom: 10px;
    background-color: var(--background);
  }
  .challenge-card:hover {
    border-color: var(--carolina-blue);
  }
</style>
