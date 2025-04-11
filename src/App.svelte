<script>
  import { onMount, onDestroy, tick } from "svelte";
  import { navigate, Router, Route } from "svelte-routing";
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

  // Components
  import Header from "./components/Header.svelte";
  import BottomNav from "./components/BottomNav.svelte";
  import TaskCompletionForm from "./components/TaskCompletionForm.svelte";
  import ChallengeCreation from "./components/ChallengeCreation.svelte";
  import LoadingSpinner from "./components/LoadingSpinner.svelte";
  import SocialFeed from "./components/SocialFeed.svelte"; // Added import

  let menuOpen = false;
  let currentUser = null;
  let appLoading = true;
  let notificationCount = 0;

  onMount(async () => {
    console.log("App mounted");

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
        navigate("/login");
      }
    });

    if ($user) {
      await fetchNotificationCount();
    }

    await tick();
    appLoading = false;

    document.addEventListener("toggleMenu", () => toggleMenu());
    document.addEventListener("logout", handleLogout);

    return () => {
      subscription.unsubscribe();
      document.removeEventListener("toggleMenu", () => toggleMenu());
      document.removeEventListener("logout", handleLogout);
    };
  });

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

  function toggleMenu() {
    menuOpen = !menuOpen;
  }

  function handleLogout() {
    supabase.auth.signOut();
    menuOpen = false;
  }
</script>

{#if appLoading}
  <div class="app-loading">
    <LoadingSpinner size="large">
      <p>Loading app...</p>
    </LoadingSpinner>
  </div>
{:else}
  <div class="app">
    <Router>
      <Header bind:menuOpen {currentUser} />
      <main>
        <Route path="/" component={Home} />
        <Route path="/challenge/:challengeId" component={ChallengeDetails} />
        <Route path="/profile" component={Profile} />
        <Route path="/profile/:username" component={PublicProfile} />
        <Route path="/login" component={Login} />
        <Route path="/signup" component={SignUp} />
        <Route path="/social" component={SocialFeed} />
        <Route path="/discover" component={Discover} />
        <Route path="/notifications" component={Notifications} />
      </main>
      <BottomNav {notificationCount} />
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
          <ChallengeCreation
            on:close={() => ($showChallengeCreation = false)}
          />
        </div>
      {/if}
      {#if $showTaskCompletionForm}
        <div
          class="modal-overlay"
          role="dialog"
          aria-label="Close task completion form"
          on:click={() => ($showTaskCompletionForm = false)}
          on:keydown={(e) => {
            if (e.key === "Enter" || e.key === "Space" || e.key === "Escape") {
              $showTaskCompletionForm = false;
            }
          }}
          tabindex="0"
        >
          <TaskCompletionForm
            on:close={() => ($showTaskCompletionForm = false)}
          />
        </div>
      {/if}
    </Router>
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
