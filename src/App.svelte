<script>
  import { onMount } from "svelte";
  import { navigate, Link } from "svelte-routing"; // Adjust if using SvelteKit
  import { user } from "./stores/user.js";
  import { supabase } from "./supabase.js";
  import ChallengeLobby from "./pages/ChallengeLobby.svelte"; // Other imports as needed

  let menuOpen = false;
  let currentUser = null;

  onMount(() => {
    currentUser = $user;
  });

  function toggleMenu() {
    menuOpen = !menuOpen;
  }

  async function logout() {
    await supabase.auth.signOut();
    $user = null;
    currentUser = null;
    navigate("/");
    menuOpen = false;
  }
</script>

<div class="app">
  <nav class="hamburger">
    <button on:click={toggleMenu} aria-label="Toggle menu">
      <span class="bar"></span>
      <span class="bar"></span>
      <span class="bar"></span>
    </button>
    {#if menuOpen}
      <div class="nav-menu" class:open={menuOpen}>
        <Link to="/" on:click={toggleMenu}>Home</Link>
        {#if currentUser}
          <Link to="/profile" on:click={toggleMenu}>Profile</Link>
          <Link to="/tokens" on:click={toggleMenu}>Tokens</Link>
          <button
            on:click={() => {
              navigate("/create-challenge");
              toggleMenu();
            }}
            class="create-btn">Create Challenge</button
          >
          <button on:click={logout} class="logout-btn">Logout</button>
        {:else}
          <Link to="/signup" on:click={toggleMenu}>Sign Up</Link>
          <Link to="/login" on:click={toggleMenu}>Login</Link>
        {/if}
      </div>
    {/if}
  </nav>

  <main>
    <ChallengeLobby />
    <!-- Routing logic here if using svelte-routing -->
  </main>
</div>

<style>
  .app {
    min-height: 100vh;
  }

  .hamburger {
    position: fixed;
    top: 1rem;
    right: 1rem;
    z-index: 20;
  }

  button {
    background: none;
    border: none;
    cursor: pointer;
  }

  .bar {
    display: block;
    width: 25px;
    height: 3px;
    margin: 5px auto;
    background-color: var(--charcoal, #333);
  }

  .nav-menu {
    position: fixed;
    top: 60px;
    right: 0;
    background-color: var(--charcoal, #333);
    padding: 1rem;
    display: none;
  }

  .nav-menu.open {
    display: block;
  }

  .create-btn,
  .logout-btn {
    display: block;
    color: var(--white, #fff);
    padding: 0.5rem;
    text-decoration: none;
  }

  .create-btn {
    background-color: var(--tomato, #ff6347);
    border: none;
    border-radius: 4px;
    margin: 0.5rem 0;
  }

  .create-btn:hover {
    background-color: var(--tomato-light, #ff8c69);
  }

  .logout-btn {
    background: none;
    border: none;
    cursor: pointer;
  }
</style>
