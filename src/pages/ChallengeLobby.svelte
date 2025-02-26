<script>
  import { onMount } from "svelte";
  import { user } from "../stores/user.js"; // Assumed user store
  import { supabase } from "../supabase.js"; // Assumed Supabase client
  import ChallengeTable from "./ChallengeTable.svelte";
  import SocialFeed from "./SocialFeed.svelte";
  import ChannelSidebar from "./ChannelSidebar.svelte";
  import CreateChallengeButton from "./CreateChallengeButton.svelte";

  let challenges = [];
  let showSidebar = false;
  let selectedChannel = null;
  let loading = true;
  let error = null;

  // Fetch challenges on mount
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

  // Toggle sidebar on logo click
  function toggleSidebar() {
    showSidebar = !showSidebar;
  }

  // Handle channel selection
  function handleChannelSelect(event) {
    selectedChannel = event.detail;
    showSidebar = false; // Close sidebar on mobile after selection
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
    <CreateChallengeButton />
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
    <section class="social-feed" class:hidden={!selectedChannel}>
      <SocialFeed channel={selectedChannel} />
    </section>
  </main>
</div>

<style>
  .challenge-lobby {
    display: flex;
    flex-direction: column;
    height: 100vh;
    background-color: var(--background, #f5f5f5);
  }

  header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 1rem;
    background-color: var(--charcoal, #333);
    color: var(--white, #fff);
  }

  .logo {
    cursor: pointer;
  }

  .logo img {
    height: 40px;
  }

  .main-content {
    display: flex;
    flex: 1;
    overflow: hidden;
  }

  .challenge-table {
    flex: 2;
    padding: 1rem;
    overflow-y: auto;
  }

  .social-feed {
    flex: 1;
    padding: 1rem;
    background-color: var(--light-gray, #e0e0e0);
    overflow-y: auto;
  }

  .signup-prompt {
    text-align: center;
    margin-bottom: 1rem;
  }

  @media (max-width: 768px) {
    .main-content {
      flex-direction: column;
    }
    .challenge-table,
    .social-feed {
      flex: none;
      width: 100%;
    }
    .social-feed {
      display: block; /* Default display */
    }

    .hidden {
      display: none; /* Class to hide the element */
    }
  }
</style>
