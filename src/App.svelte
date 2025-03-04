<script>
  import { onMount, onDestroy } from "svelte";
  import { navigate, Router, Route, Link } from "svelte-routing";
  import { showChallengeCreation, user } from "./stores.js";
  import { showTaskCompletionForm } from "./stores.js";
  import TaskButtonWithMenu from "./components/TaskButtonWithMenu.svelte";
  import TaskCompletionForm from "./pages/TaskCompletionForm.svelte";
  import { supabase } from "./supabase.js";
  import ChallengeLobby from "./pages/ChallengeLobby.svelte";
  import ChallengeDetails from "./pages/ChallengeDetails.svelte";
  import SocialFeed from "./pages/SocialFeed.svelte";
  import BottomNav from "./components/BottomNav.svelte";
  import ChallengeCreation from "./pages/ChallengeCreation.svelte";
  import Profile from "./pages/Profile.svelte";
  import Login from "./pages/Login.svelte";
  import PublicProfile from "./pages/PublicProfile.svelte";
  import Fa from "svelte-fa";
  import {
    faHome,
    faTrophy,
    faUsers,
    faNewspaper,
  } from "@fortawesome/free-solid-svg-icons";

  let menuOpen = false;
  let currentUser = null;
  let isMobile = window.innerWidth < 769;
  let showTaskCompletionFormValue;
  showTaskCompletionForm.subscribe(
    (value) => (showTaskCompletionFormValue = value)
  );

  function handleResize() {
    isMobile = window.innerWidth < 769;
  }

  onMount(async () => {
    console.log("App mounted");
    window.addEventListener("resize", handleResize);

    const {
      data: { user: authUser },
    } = await supabase.auth.getUser();
    console.log("Supabase auth user on mount:", authUser);
    if (authUser) {
      currentUser = authUser;
      $user = authUser;
    }

    supabase.auth.onAuthStateChange((event, session) => {
      currentUser = session?.user ?? null;
      $user = currentUser;
      console.log("Auth state changed:", event, "User:", currentUser);
      if (!currentUser) {
        navigate("/login");
      }
    });
  });

  onDestroy(() => {
    window.removeEventListener("resize", handleResize);
  });

  function toggleMenu(event) {
    event.stopPropagation();
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
      {#if !isMobile && $user}
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
          <TaskButtonWithMenu
            menuPosition="below"
            buttonWidth="40px"
            buttonHeight="40px"
          />
          <Link
            to="/social"
            class={window.location.pathname === "/social" ? "active" : ""}
          >
            <Fa icon={faUsers} size="lg" />
            <span>Social</span>
          </Link>
          <Link
            to="/news"
            class={window.location.pathname === "/news" ? "active" : ""}
          >
            <Fa icon={faNewspaper} size="lg" />
            <span>News</span>
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
            class="create-btn"
          >
            Create Challenge
          </button>
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
      <Route path="/social">
        <div class="social-feed-container">
          <h2>#bl0b-general</h2>
          <SocialFeed challengeId={null} challengeName="bl0b-general" />
        </div>
      </Route>
      <Route path="/leaderboards" component={ChallengeLobby} />
      <Route path="/profile" component={Profile} />
      <Route path="/profile/:username" component={PublicProfile} />
      <Route path="/tokens" component={ChallengeLobby} />
      <Route path="/signup" component={ChallengeLobby} />
      <Route path="/login" component={Login} />
      <Route path="/challenge/:challengeId" component={ChallengeDetails} />
    </main>

    {#if isMobile && $user}
      <BottomNav
        activeTab={window.location.pathname === "/"
          ? "home"
          : window.location.pathname.slice(1)}
      />
    {/if}

    {#if $showChallengeCreation}
      <ChallengeCreation />
    {/if}

    {#if showTaskCompletionFormValue}
      <div
        class="modal-overlay"
        on:click={() => showTaskCompletionForm.set(false)}
        on:keydown={(e) =>
          e.key === "Escape" && showTaskCompletionForm.set(false)}
        role="presentation"
      >
        <TaskCompletionForm
          on:close={() => showTaskCompletionForm.set(false)}
        />
      </div>
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
    z-index: 1000; /* Increased for overlay */
    position: fixed; /* Changed from sticky to fixed */
    top: 0;
    left: 0;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2); /* Optional: adds depth */
  }

  .logo img {
    height: 40px;
    cursor: pointer;
  }

  .top-nav {
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: center;
    gap: 2rem;
    width: 100%;
    max-width: 500px;
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
    position: fixed; /* Changed from absolute to fixed */
    top: 60px; /* Matches header height */
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
    padding: 70px 1rem 120px 1rem; /* Increased top padding to account for fixed header */
    overflow-y: auto;
    max-width: 900px;
    width: 100%;
    margin: 0 auto;
  }

  .modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 2000;
  }

  .social-feed-container {
    background: var(--white);
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    padding: 1rem;
    margin-top: 2rem;
  }

  h2 {
    font-size: 1.2rem;
    color: var(--charcoal);
    text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1);
    margin-bottom: 1rem;
  }
</style>
