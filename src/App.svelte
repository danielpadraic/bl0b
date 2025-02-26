<script>
  import { Router, Route } from "svelte-routing";
  import { user } from "./stores/user.js";
  import Login from "./pages/Login.svelte";
  import SignUp from "./pages/SignUp.svelte";
  import ChallengeLobby from "./pages/ChallengeLobby.svelte";
  import SocialFeed from "./pages/SocialFeed.svelte";
  import Leaderboards from "./pages/Leaderboards.svelte";
  import ChallengeCreation from "./pages/ChallengeCreation.svelte";
  import ChallengeDetails from "./pages/ChallengeDetails.svelte";
  import Profile from "./pages/Profile.svelte";
  import TokenPurchase from "./pages/TokenPurchase.svelte";
  import BottomNav from "./components/BottomNav.svelte";
  import { Fa } from "svelte-fa";
  import { faBars } from "@fortawesome/free-solid-svg-icons";
  import { supabase } from "./supabase.js";
  import { navigate } from "svelte-routing";

  let currentUser;
  let menuOpen = false;
  let currentPath = window.location.pathname;

  user.subscribe((value) => (currentUser = value));

  function toggleMenu() {
    menuOpen = !menuOpen;
  }

  function handleRouteChange(event) {
    currentPath = event.detail.path || window.location.pathname;
  }

  async function logout() {
    const { error } = await supabase.auth.signOut();
    if (error) {
      console.error("Logout failed:", error.message);
    } else {
      user.set(null);
      navigate("/login");
      menuOpen = false;
    }
  }

  function goHome() {
    navigate("/");
    menuOpen = false; // Close menu if open
  }
</script>

{#if currentPath !== "/login"}
  <nav class="top-nav">
    <div class="nav-left">
      <button class="logo-btn" on:click={goHome}>
        <img src="/assets/logo.png" alt="blOb Logo" class="logo" />
      </button>
    </div>
    <button class="hamburger" on:click={toggleMenu}>
      <Fa icon={faBars} />
    </button>
    {#if menuOpen || currentPath !== "/login"}
      <div class="nav-menu" class:open={menuOpen}>
        {#if currentUser}
          <a href="/profile" on:click={toggleMenu} class="dark-bg-text"
            >Profile</a
          >
          <a href="/tokens" on:click={toggleMenu} class="dark-bg-text">Tokens</a
          >
          <a href="/create-challenge" on:click={toggleMenu} class="dark-bg-text"
            >Create Challenge</a
          >
          <button on:click={logout} class="logout-btn">Logout</button>
        {:else}
          <a href="/signup" on:click={toggleMenu} class="dark-bg-text"
            >Sign Up</a
          >
          <a href="/login" on:click={toggleMenu} class="dark-bg-text">Login</a>
        {/if}
      </div>
    {/if}
  </nav>
{/if}

<main>
  <Router on:routeChanged={handleRouteChange}>
    {#if currentUser}
      <Route path="/" component={ChallengeLobby} />
      <Route path="/social" component={SocialFeed} />
      <Route path="/leaderboards" component={Leaderboards} />
      <Route path="/create-challenge" component={ChallengeCreation} />
      <Route
        path="/challenge/:id"
        component={ChallengeDetails}
        let:params={{ id }}
      />
      <Route path="/profile" component={Profile} />
      <Route path="/tokens" component={TokenPurchase} />
    {:else}
      <Route path="/login" component={Login} />
      <Route path="/signup" component={SignUp} />
      <Route path="*" component={Login} />
    {/if}
  </Router>
</main>

{#if currentPath !== "/login"}
  <BottomNav activeTab={currentPath === "/" ? "home" : currentPath.slice(1)} />
{/if}

<style>
  .top-nav {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    background-color: var(--charcoal);
    padding: 10px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    z-index: 10;
  }
  .nav-left {
    display: flex;
    align-items: center;
  }
  .logo-btn {
    background: none;
    border: none;
    padding: 0;
    cursor: pointer;
  }
  .logo {
    width: 50px;
    height: auto;
    margin-right: 10px;
  }
  .hamburger {
    background: none;
    border: none;
    color: var(--background);
    font-size: 1.5rem;
    cursor: pointer;
  }
  .nav-menu {
    display: none;
    flex-direction: column;
    position: absolute;
    top: 60px;
    left: 0;
    width: 100%;
    background-color: var(--charcoal);
    padding: 10px;
  }
  .nav-menu.open {
    display: flex;
  }
  .nav-menu a {
    color: var(--carolina-blue);
    text-decoration: none;
    padding: 10px;
    font-size: 1rem;
  }
  .nav-menu a:hover {
    color: var(--tomato-light);
  }
  .logout-btn {
    background: none;
    border: none;
    color: var(--carolina-blue);
    padding: 10px;
    font-size: 1rem;
    cursor: pointer;
    text-align: left;
  }
  .logout-btn:hover {
    color: var(--tomato-light);
  }
  main {
    padding: 70px 10px 60px;
  }

  @media (min-width: 768px) {
    .hamburger {
      display: none;
    }
    .nav-menu {
      display: flex;
      flex-direction: row;
      position: static;
      width: auto;
      background: none;
      padding: 0;
    }
    .nav-menu a,
    .nav-menu .logout-btn {
      margin-left: 20px;
    }
    main {
      padding: 80px 20px 70px;
    }
  }
</style>
