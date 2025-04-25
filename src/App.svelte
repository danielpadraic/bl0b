<script>
  import { onMount, onDestroy } from "svelte";
  import { navigate } from "svelte-routing";
  import {
    showChallengeCreation,
    user,
    showTaskCompletionForm,
  } from "./stores.js";
  import { supabase } from "./supabase.js";

  // Pages
  import Home from "./pages/Home.svelte";
  import ChallengeDetails from "./pages/ChallengeDetails.svelte";
  import Profile from "./pages/Profile.svelte";
  import PublicProfile from "./pages/PublicProfile.svelte";
  import Login from "./pages/Login.svelte";
  import SignUp from "./pages/SignUp.svelte";
  import Discover from "./pages/Discover.svelte";
  import Notifications from "./pages/Notifications.svelte";
  import SocialFeed from "./components/SocialFeed.svelte";

  // Components
  import Header from "./components/Header.svelte";
  import BottomNav from "./components/BottomNav.svelte";
  import TaskCompletionForm from "./components/TaskCompletionForm.svelte";
  import ChallengeCreation from "./components/ChallengeCreation.svelte";
  import LoadingSpinner from "./components/LoadingSpinner.svelte";
  import StoryViewer from "./components/StoryViewer.svelte";
  import StoryCreator from "./components/StoryCreator.svelte";

  let menuOpen = false;
  let currentUser = null;
  let appLoading = true;
  let notificationCount = 0;
  let currentPage = "home";
  let pageProps = {};

  // Create functions for event handlers to ensure proper cleanup
  function handleToggleMenu() {
    console.log("toggleMenu event received in App.svelte");
    toggleMenu();
  }

  function handleLogout() {
    supabase.auth.signOut();
    menuOpen = false;
  }

  function handlePopstate() {
    handleNavigate(window.location.pathname);
  }

  // Simple router function
  function handleNavigate(path) {
    if (typeof path !== "string") return;
    const parts = path.split("/").filter(Boolean);

    if (parts.length === 0 || path === "/") {
      currentPage = "home";
      pageProps = {};
    } else if (parts[0] === "challenge" && parts.length > 1) {
      currentPage = "challenge";
      pageProps = { challengeId: parts[1] };
    } else if (parts[0] === "profile" && parts.length > 1) {
      currentPage = "public-profile";
      pageProps = { username: parts[1] };
    } else if (parts[0] === "profile") {
      currentPage = "profile";
      pageProps = {};
    } else if (parts[0] === "login") {
      currentPage = "login";
      pageProps = {};
    } else if (parts[0] === "signup") {
      currentPage = "signup";
      pageProps = {};
    } else if (parts[0] === "social") {
      currentPage = "social";
      pageProps = {};
    } else if (parts[0] === "discover") {
      currentPage = "discover";
      pageProps = {};
    } else if (parts[0] === "notifications") {
      currentPage = "notifications";
      pageProps = {};
    } else if (parts[0] === "story" && parts.length > 1) {
      currentPage = "story-viewer";
      pageProps = { storyId: parts[1] };
    } else if (parts[0] === "stories" && parts.length > 1) {
      currentPage = "story-viewer";
      pageProps = { username: parts[1] };
    } else if (parts[0] === "create-story") {
      currentPage = "story-creator";
      pageProps = {};
    } else {
      currentPage = "not-found";
      pageProps = {};
    }
  }

  // Patch the navigate function from svelte-routing
  window.navigateTo = (path) => {
    handleNavigate(path);
    window.history.pushState({}, "", path);
  };

  function toggleMenu() {
    menuOpen = !menuOpen;
    console.log("App.svelte: menuOpen toggled to", menuOpen);
  }

  async function fetchNotificationCount() {
    if (!$user) return;

    try {
      const { count, error } = await supabase
        .from("notifications")
        .select("id", { count: "exact" })
        .eq("user_id", $user.id)
        .eq("read", false);

      if (!error) {
        notificationCount = count || 0;
      }
    } catch (err) {
      console.error("Error fetching notifications:", err);
    }
  }

  onMount(async () => {
    console.log("App mounted");

    // Handle initial path
    handleNavigate(window.location.pathname);

    // Add popstate listener for back/forward navigation
    window.addEventListener("popstate", handlePopstate);

    const {
      data: { session },
    } = await supabase.auth.getSession();

    if (session) {
      currentUser = session.user;
      $user = session.user;
      console.log("Session found, user authenticated:", session.user);
    } else {
      console.log("No session found");
    }

    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((event, session) => {
      console.log("Auth state changed:", event, session);
      currentUser = session?.user ?? null;
      $user = currentUser;
      if (event === "SIGNED_OUT") {
        window.navigateTo("/login");
      }
    });

    if ($user) {
      await fetchNotificationCount();
    }

    appLoading = false;

    // Add event listeners with proper reference to functions
    document.addEventListener("toggleMenu", handleToggleMenu);
    document.addEventListener("logout", handleLogout);

    return () => {
      // Clean up resources
      subscription.unsubscribe();

      // Remove event listeners with the same function references
      document.removeEventListener("toggleMenu", handleToggleMenu);
      document.removeEventListener("logout", handleLogout);
      window.removeEventListener("popstate", handlePopstate);
    };
  });
</script>

{#if appLoading}
  <div class="app-loading">
    <LoadingSpinner size="large">
      <p>Loading app...</p>
    </LoadingSpinner>
  </div>
{:else}
  <div class="app">
    <Header bind:menuOpen {currentUser} />
    <main>
      {#if currentPage === "home"}
        <Home />
      {:else if currentPage === "challenge"}
        <ChallengeDetails challengeId={pageProps.challengeId} />
      {:else if currentPage === "story-creator"}
        <StoryCreator />
      {:else if currentPage === "profile"}
        <Profile />
      {:else if currentPage === "story-viewer"}
        <StoryViewer
          storyId={pageProps.storyId}
          username={pageProps.username}
        />
      {:else if currentPage === "public-profile"}
        <PublicProfile username={pageProps.username} />
      {:else if currentPage === "login"}
        <Login />
      {:else if currentPage === "signup"}
        <SignUp />
      {:else if currentPage === "social"}
        <SocialFeed />
      {:else if currentPage === "discover"}
        <Discover />
      {:else if currentPage === "notifications"}
        <Notifications />
      {:else}
        <div class="not-found">
          <h1>Page Not Found</h1>
          <p>Sorry, the page you're looking for doesn't exist.</p>
          <button on:click={() => window.navigateTo("/")}>Go Home</button>
        </div>
      {/if}
    </main>
    <BottomNav {notificationCount} activeTab={currentPage} />
    {#if $showChallengeCreation}
      <div
        class="modal-overlay"
        on:click={() => ($showChallengeCreation = false)}
        on:keydown={(e) => {
          if (e.key === "Enter" || e.key === "Space") {
            $showChallengeCreation = false;
          }
        }}
        role="button"
        tabindex="0"
      >
        <ChallengeCreation on:close={() => ($showChallengeCreation = false)} />
      </div>
    {/if}
    {#if $showTaskCompletionForm}
      <div class="modal-overlay" role="dialog" aria-modal="true">
        <div
          class="modal-dialog-container"
          on:click|self={() => ($showChallengeCreation = false)}
        >
          <ChallengeCreation
            on:close={() => ($showChallengeCreation = false)}
          />
        </div>
      </div>
    {/if}
  </div>
{/if}

<style>
  .app {
    width: 100%;
    min-height: 100vh;
    background-color: var(--background);
    color: var(--text);
    position: relative;
    display: flex;
    flex-direction: column;
  }

  main {
    flex: 1;
    min-height: calc(100vh - 120px);
    width: 100%;
    max-width: 100vw;
    overflow-x: hidden;
  }

  .app-loading {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: var(--background);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 9999;
  }

  .modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(0, 0, 0, 0.6);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 1000;
  }

  .modal-dialog-container {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 100%;
    height: 100%;
  }

  .not-found {
    text-align: center;
    padding: 60px 20px;
  }

  .not-found h1 {
    font-size: 2rem;
    color: var(--tomato);
    margin-bottom: 16px;
  }

  .not-found button {
    margin-top: 24px;
    background-color: var(--tomato);
    color: white;
    border: none;
    border-radius: 8px;
    padding: 12px 24px;
    font-weight: 600;
    cursor: pointer;
  }

  :global(body) {
    margin: 0;
    padding: 0;
    font-family: Arial, sans-serif;
    overflow-x: hidden;
    background-color: var(--background);
  }

  @media (hover: none) {
    :global(body) {
      -webkit-tap-highlight-color: transparent;
      -webkit-touch-callout: none;
      user-select: none;
    }
  }
</style>
