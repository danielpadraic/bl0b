<script>
  import { onMount, onDestroy } from "svelte";
  import { navigate, Router, Route, Link } from "svelte-routing";
  import { showChallengeCreation, user } from "./stores.js";
  import { supabase } from "./supabase.js";
  import ChallengeLobby from "./pages/ChallengeLobby.svelte";
  import SocialFeed from "./pages/SocialFeed.svelte";
  import BottomNav from "./components/BottomNav.svelte";
  import ChallengeCreation from "./pages/ChallengeCreation.svelte";
  import Profile from "./pages/Profile.svelte";
  import Login from "./pages/Login.svelte"; // Correct import
  import SignUp from "./pages/SignUp.svelte";
  import Fa from "svelte-fa";
  import { faHome, faTrophy, faUsers } from "@fortawesome/free-solid-svg-icons";

  let menuOpen = false;
  let currentUser = null;
  let isMobile = window.innerWidth < 769;

  function handleResize() {
    isMobile = window.innerWidth < 769;
  }

  onMount(() => {
    console.log("App mounted");
    window.addEventListener("resize", handleResize);
    supabase.auth.onAuthStateChange((event, session) => {
      currentUser = session?.user ?? null;
      $user = currentUser;
    });
    supabase.auth.getUser().then(({ data: { user: initialUser } }) => {
      currentUser = initialUser || null;
      $user = currentUser;
    });
  });

  onDestroy(() => {
    window.removeEventListener("resize", handleResize);
  });

  function toggleMenu() {
    menuOpen = !menuOpen;
    console.log("Menu toggled:", menuOpen);
  }

  function toggleChallengeCreation() {
    $showChallengeCreation = !$showChallengeCreation;
    console.log("Challenge creation toggled:", $showChallengeCreation);
  }

  async function logout() {
    await supabase.auth.signOut();
    currentUser = null;
    $user = null;
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
      <Route path="/login" component={Login} />
      <Route path="/signup" component={SignUp} />
      <Route path="/social" component={SocialFeed} />
      <Route path="/leaderboards" component={ChallengeLobby} />
      <Route path="/profile" component={Profile} />
      <Route path="/tokens" component={ChallengeLobby} />
      <Route path="*" component={ChallengeLobby} />
      <!-- Catch-all at the end -->
    </main>

    {#if isMobile && currentUser}
      <BottomNav
        activeTab={window.location.pathname === "/"
          ? "home"
          : window.location.pathname.slice(1)}
      />
    {/if}

    {#if $showChallengeCreation}
      <ChallengeCreation />
    {/if}
  </Router>
</div>

<style>
  .app {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    background-color: var(--background);
    color: var(--text);
  }

  header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 1rem;
    background-color: var(--charcoal);
    color: var(--white);
    width: 100%;
    z-index: 10;
    position: sticky;
    top: 0;
  }

  .logo img {
    height: 40px;
    cursor: pointer;
  }

  .top-nav {
    display: flex;
    flex-direction: row;
    justify-content: space-evenly;
    align-items: center;
    gap: 2rem;
    width: 100%;
    max-width: 400px;
  }

  :global(.top-nav a) {
    color: var(--carolina-blue) !important;
    text-decoration: none !important;
    display: flex;
    flex-direction: column !important;
    align-items: center !important;
    font-size: clamp(0.8rem, 2vw, 1rem) !important;
  }

  :global(.top-nav a:link) {
    color: var(--carolina-blue) !important;
  }

  :global(.top-nav a:visited) {
    color: var(--carolina-blue) !important;
  }

  :global(.top-nav a.active) {
    color: var(--tomato) !important;
  }

  :global(.top-nav a:hover) {
    color: var(--tomato-light) !important;
  }

  :global(.top-nav a span) {
    margin-top: 0.3rem !important;
  }

  .hamburger {
    background: none;
    border: none;
    cursor: pointer;
    display: flex;
    flex-direction: column;
    gap: 0.3rem;
  }

  .bar {
    width: 25px;
    height: 3px;
    background-color: var(--white);
  }

  .nav-menu {
    position: absolute;
    top: 60px;
    right: 0;
    background-color: var(--charcoal);
    padding: 1rem;
    border-radius: 0 0 0 8px;
    z-index: 1000;
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
  }

  :global(.nav-menu a) {
    color: var(--carolina-blue);
    text-decoration: none;
    padding: 0.5rem 1rem;
  }

  :global(.nav-menu a:hover) {
    color: var(--tomato-light);
  }

  .create-btn {
    background-color: var(--tomato);
    color: var(--background);
    border: 2px solid var(--tomato);
    padding: 0.5rem 1rem;
    border-radius: 4px;
    cursor: pointer;
    font-size: 1rem;
    margin-top: 0.5rem;
  }

  .create-btn:hover {
    background-color: var(--tomato-light);
    border-color: var(--tomato-light);
  }

  .logout-btn {
    background-color: var(--hunyadi-yellow);
    color: var(--background);
    border: 2px solid var(--hunyadi-yellow);
    padding: 0.5rem 1rem;
    border-radius: 4px;
    cursor: pointer;
    font-size: 1rem;
    margin-top: 0.5rem;
  }

  .logout-btn:hover {
    background-color: #e69a26;
    border-color: #e69a26;
  }

  main {
    flex: 1;
    padding: 1rem 1rem 80px 1rem;
    overflow-y: auto;
    max-height: calc(100vh - 60px);
  }
</style>
