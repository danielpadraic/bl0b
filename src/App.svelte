<script>
  import { onMount } from "svelte";
  import { navigate, Link } from "svelte-routing";
  import { user } from "./stores/user.js";
  import { supabase } from "./supabase.js";
  import ChallengeLobby from "./ChallengeLobby.svelte";
  import BottomNav from "./components/BottomNav.svelte";

  let menuOpen = false;
  let currentUser = null;
  let isMobile = window.innerWidth < 769;

  onMount(() => {
    currentUser = $user;
    window.addEventListener("resize", () => {
      isMobile = window.innerWidth < 769;
    });
  });

  function toggleMenu() {
    menuOpen = !menuOpen;
  }

  async function logout() {
    await supabase.auth.signOut();
    $user = null;
    currentUser = null;
    navigate("/login");
    menuOpen = false;
  }

  function goHome() {
    navigate("/");
    menuOpen = false;
  }
</script>

<div class="app">
  <header>
    <div
      class="logo"
      on:click={goHome}
      role="button"
      tabindex="0"
      on:keydown={(e) => e.key === "Enter" && goHome()}
    >
      <img src="/assets/logo.png" alt="blOb Logo" />
    </div>
    {#if !isMobile}
      <nav class="top-nav">
        <Link to="/" class="nav-item">Home</Link>
        <Link to="/leaderboards" class="nav-item">Leaderboards</Link>
        <Link to="/social" class="nav-item">Social</Link>
      </nav>
    {/if}
    <button class="hamburger" on:click={toggleMenu} aria-label="Toggle menu">
      <span class="bar"></span>
      <span class="bar"></span>
      <span class="bar"></span>
    </button>
    {#if menuOpen}
      <div class="nav-menu" class:open={menuOpen}>
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
  </header>

  <main>
    <ChallengeLobby />
  </main>

  {#if isMobile && currentUser}
    <BottomNav
      activeTab={window.location.pathname === "/"
        ? "home"
        : window.location.pathname.slice(1)}
    />
  {/if}
</div>

<style>
  .app {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
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

  .top-nav {
    display: flex;
    gap: 1rem;
  }

  .nav-item {
    color: var(--white);
    text-decoration: none;
    font-size: clamp(0.9rem, 2vw, 1rem);
  }

  .nav-item:hover {
    color: var(--tomato-light);
  }

  .hamburger {
    background: none;
    border: none;
    cursor: pointer;
    z-index: 20;
  }

  .bar {
    display: block;
    width: 25px;
    height: 3px;
    margin: 5px auto;
    background-color: var(--white);
  }

  .nav-menu {
    position: fixed;
    top: 60px;
    right: 0;
    background-color: var(--charcoal);
    padding: 1rem;
    display: none;
    z-index: 15;
  }

  .nav-menu.open {
    display: block;
  }

  a,
  .create-btn,
  .logout-btn {
    display: block;
    color: var(--white);
    padding: 0.5rem;
    text-decoration: none;
  }

  .create-btn {
    background-color: var(--tomato);
    border: none;
    border-radius: 4px;
    margin: 0.5rem 0;
  }

  .create-btn:hover {
    background-color: var(--tomato-light);
  }

  .logout-btn {
    background: none;
    border: none;
    cursor: pointer;
  }

  main {
    flex: 1;
    overflow-y: auto;
  }
</style>
