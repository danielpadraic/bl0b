<script>
  import { onMount, onDestroy } from "svelte";
  import { navigate, Router, Route, Link } from "svelte-routing";
  import { user } from "./stores/user.js";
  import { supabase } from "./supabase.js";
  import ChallengeLobby from "./pages/ChallengeLobby.svelte";
  import SocialFeed from "./pages/SocialFeed.svelte";
  import BottomNav from "./components/BottomNav.svelte";

  let menuOpen = false;
  let currentUser = null;
  let isMobile = window.innerWidth < 769;

  function handleResize() {
    isMobile = window.innerWidth < 769;
  }

  onMount(() => {
    currentUser = $user;
    window.addEventListener("resize", handleResize);
    supabase.auth.onAuthStateChange((event, session) => {
      currentUser = session?.user ?? null;
      $user = currentUser;
    });
  });

  onDestroy(() => {
    window.removeEventListener("resize", handleResize);
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
  </header>

  {#if menuOpen}
    <div class="nav-menu">
      {#if currentUser}
        <Link to="/profile" on:click={toggleMenu}>Profile</Link>
        <Link to="/tokens" on:click={toggleMenu}>Tokens</Link>
        <button
          on:click={() => {
            navigate("/create-challenge");
            toggleMenu();
          }}>Create Challenge</button
        >
        <button on:click={logout}>Logout</button>
      {:else}
        <Link to="/signup" on:click={toggleMenu}>Sign Up</Link>
        <Link to="/login" on:click={toggleMenu}>Login</Link>
      {/if}
    </div>
  {/if}

  <main>
    <Router>
      <Route path="/" component={ChallengeLobby} />
      <Route path="/social" component={SocialFeed} />
      <Route path="/leaderboards" component={ChallengeLobby} />
      <Route path="/profile" component={ChallengeLobby} />
      <Route path="/tokens" component={ChallengeLobby} />
      <Route path="/create-challenge" component={ChallengeLobby} />
      <Route path="/signup" component={ChallengeLobby} />
      <Route path="/login" component={ChallengeLobby} />
    </Router>
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
    padding: 1rem;
    background-color: #333;
    color: white;
    width: 100%;
  }

  .logo img {
    height: 40px;
  }

  .top-nav {
    display: flex;
    gap: 1rem;
  }

  .nav-item {
    color: white;
    text-decoration: none;
  }

  .nav-item:hover {
    color: #ff6347;
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
    margin: 5px 0;
    background-color: white;
  }

  .nav-menu {
    position: absolute;
    top: 60px;
    right: 0;
    background-color: #333;
    padding: 1rem;
    width: 200px;
    z-index: 15;
  }

  .nav-menu a,
  .nav-menu button {
    display: block;
    color: white;
    padding: 0.5rem;
    text-decoration: none;
    background: none;
    border: none;
    width: 100%;
    text-align: left;
  }

  .nav-menu button:hover,
  .nav-menu a:hover {
    color: #ff6347;
  }

  main {
    flex: 1;
  }
</style>
