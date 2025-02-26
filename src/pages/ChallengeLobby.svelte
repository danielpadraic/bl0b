<script>
  import { onMount } from "svelte";
  import { user } from "../stores/user.js";
  import { supabase } from "../supabase.js";
  import ChallengeTable from "./ChallengeTable.svelte";
  import ChannelSidebar from "./ChannelSidebar.svelte";

  let challenges = [];
  let showSidebar = false;
  let selectedChannel = null;
  let loading = true;
  let error = null;

  onMount(async () => {
    const { data, error: fetchError } = await supabase
      .from("challenges")
      .select("*")
      .order("created_at", { ascending: false });

    if (fetchError) {
      error = fetchError.message;
    } else {
      challenges = data;
    }
    loading = false;
  });

  function toggleSidebar() {
    showSidebar = !showSidebar;
  }

  function handleChannelSelect(event) {
    selectedChannel = event.detail;
    showSidebar = false;
  }
</script>

<div class="challenge-lobby">
  <header>
    <div
      class="logo"
      on:click={toggleSidebar}
      role="button"
      tabindex="0"
      on:keydown={(e) => e.key === "Enter" && toggleSidebar()}
    >
      <img src="/assets/logo.png" alt="blOb Logo" />
    </div>
  </header>

  <main class="main-content">
    {#if showSidebar}
      <ChannelSidebar on:select={handleChannelSelect} />
    {/if}
    <section class="challenge-table">
      {#if !$user}
        <p class="signup-prompt">
          Please <a href="/signup">sign up</a> to join challenges or participate!
        </p>
      {/if}
      <ChallengeTable {challenges} {loading} {error} />
    </section>
  </main>
</div>

<style>
  .challenge-lobby {
    display: flex;
    flex-direction: column;
    height: 100vh;
  }

  header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: clamp(0.5rem, 2vw, 1rem);
    background-color: var(--charcoal);
    color: var(--white);
    position: relative;
    z-index: 10;
  }

  .logo {
    cursor: pointer;
  }

  .logo img {
    height: clamp(2rem, 5vw, 3rem);
  }

  .main-content {
    flex: 1;
    overflow: hidden;
  }

  .challenge-table {
    flex: 2;
    overflow-y: auto;
  }

  .signup-prompt {
    text-align: center;
    padding: clamp(0.5rem, 2vw, 1rem);
  }
</style>
