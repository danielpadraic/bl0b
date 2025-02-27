<script>
  import { onMount, onDestroy } from "svelte";
  import { navigate, Router, Route, Link } from "svelte-routing";
  import { showChallengeCreation } from "./stores.js";
  import { supabase } from "./supabase.js";
  import ChallengeLobby from "./pages/ChallengeLobby.svelte";
  import SocialFeed from "./pages/SocialFeed.svelte";
  import BottomNav from "./components/BottomNav.svelte";
  import ChallengeCreation from "./pages/ChallengeCreation.svelte";
  import Fa from "svelte-fa";
  import { faHome, faTrophy, faUsers } from "@fortawesome/free-solid-svg-icons";

  let menuOpen = false;
  let currentUser = null;
  let isMobile = window.innerWidth < 769;

  function handleResize() {
    isMobile = window.innerWidth < 769;
  }

  onMount(() => {
    window.addEventListener("resize", handleResize);
    supabase.auth.onAuthStateChange((event, session) => {
      currentUser = session?.user ?? null;
    });
  });

  onDestroy(() => {
    window.removeEventListener("resize", handleResize);
  });

  function toggleMenu() {
    menuOpen = !menuOpen;
  }

  function toggleChallengeCreation() {
    $showChallengeCreation = !$showChallengeCreation;
  }

  async function logout() {
    await supabase.auth.signOut();
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
  <Router>
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
          <Link to="/" class={window.location.pathname === "/" ? "active" : ""}>
            <Fa icon={faHome} size="lg" />
            <span>Home</span>
          </Link>
          <Link
            to="/leaderboards"
            class={window.location.pathname === "/leaderboards" ? "active" : ""}
          >
            <Fa icon={faTrophy} size="lg" />
            <span>Leaderboards</span>
          </Link>
          <Link
            to="/social"
            class={window.location.pathname === "/social" ? "active" : ""}
          >
            <Fa icon={faUsers} size="lg" />
            <span>Social</span>
          </Link>
        </nav>
      {/if}
      <button class="hamburger" on:click={toggleMenu} aria-label="Toggle menu">
        <span class="bar"></span>
        <span class="bar"></span>
        <span class="bar"></span>
      </button>
    </header>

    {#if menuOpen}
      <div class="nav-menu">
        {#if currentUser}
          <Link to="/profile" on:click={toggleMenu} class="dark-bg-text"
            >Profile</Link
          >
          <Link to="/tokens" on:click={toggleMenu} class="dark-bg-text"
            >Tokens</Link
          >
          <button
            on:click={() => {
              toggleChallengeCreation();
              toggleMenu();
            }}
            class="create-btn">Create Challenge</button
          >
          <button on:click={logout} class="logout-btn">Logout</button>
        {:else}
          <Link to="/signup" on:click={toggleMenu} class="dark-bg-text"
            >Sign Up</Link
          >
          <Link to="/login" on:click={toggleMenu} class="dark-bg-text"
            >Login</Link
          >
        {/if}
      </div>
    {/if}

    <main>
      <Route path="/" component={ChallengeLobby} />
      <Route path="/social" component={SocialFeed} />
      <Route path="/leaderboards" component={ChallengeLobby} />
      <Route path="/profile" component={ChallengeLobby} />
      <Route path="/tokens" component={ChallengeLobby} />
      <Route path="/signup" component={ChallengeLobby} />
      <Route path="/login" component={ChallengeLobby} />
    </main>

    {#if isMobile && currentUser}
      <BottomNav
        activeTab={window.location.pathname === "/"
          ? "home"
          : window.location.pathname.slice(1)}
      />
    {/if}

    {#if $showChallengeCreation}
      <ChallengeCreation
        on:challengeCreated={() => ($showChallengeCreation = false)}
      />
    {/if}
  </Router>
</div>

<style>
  .app {
    display: flex;
    flex-direction: column;
    min-height: 100vh;
  }
  header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px 20px;
    background-color: #f8f9fa;
  }
  .logo img {
    height: 40px;
    cursor: pointer;
  }
  .top-nav {
    display: flex;
    gap: 20px;
  }
  .top-nav a {
    display: flex;
    align-items: center;
    gap: 5px;
    text-decoration: none;
    color: #333;
  }
  .top-nav a.active {
    color: #007bff;
    font-weight: bold;
  }
  .hamburger {
    display: flex;
    flex-direction: column;
    gap: 5px;
    background: none;
    border: none;
    cursor: pointer;
  }
  .bar {
    width: 25px;
    height: 3px;
    background-color: #333;
  }
  .nav-menu {
    position: absolute;
    top: 60px;
    right: 20px;
    background-color: #333;
    color: white;
    padding: 20px;
    border-radius: 5px;
    z-index: 1000;
  }
  .nav-menu a {
    display: block;
    margin: 10px 0;
    color: white;
    text-decoration: none;
  }
  .dark-bg-text {
    color: white;
  }
  main {
    flex: 1;
    padding: 20px;
  }
  .create-btn {
    background-color: #007bff;
    color: white;
    padding: 10px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
  }
  .create-btn:hover {
    background-color: #0056b3;
  }
  .logout-btn {
    background-color: #dc3545;
    color: white;
    padding: 10px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
  }
  .logout-btn:hover {
    background-color: #c82333;
  }
</style>
