<script>
  import { onMount, onDestroy } from "svelte";
  import {
    showTaskCompletionForm,
    showChallengeCreation,
    user,
  } from "../stores.js";

  // Props
  export let activeTab = "home";
  export let notificationCount = 0;

  // Menu state
  let showCreateMenu = false;

  // Handle navigation
  function navigateTo(route) {
    // Use the custom navigation function added to the window object
    if (window.navigateTo) {
      window.navigateTo(route);
    } else {
      // Fallback to simple location change if navigateTo isn't available
      window.location.href = route;
    }

    // Close menu if it was open
    showCreateMenu = false;
  }

  // Handle create menu toggle
  function toggleCreateMenu() {
    showCreateMenu = !showCreateMenu;
  }

  // Close menu if clicked outside
  function handleDocumentClick(event) {
    const actionButton = document.querySelector(".action-button");
    const createMenu = document.querySelector(".create-menu");

    if (showCreateMenu && actionButton && createMenu) {
      if (
        !actionButton.contains(event.target) &&
        !createMenu.contains(event.target)
      ) {
        showCreateMenu = false;
      }
    }
  }

  // Handle action selection
  function handleAction(action) {
    showCreateMenu = false;

    switch (action) {
      case "task":
        showTaskCompletionForm.set(true);
        break;
      case "challenge":
        showChallengeCreation.set(true);
        break;
      case "story":
        navigateTo("/create-story");
        break;
      case "post":
        // Navigate to home and focus on post input
        navigateTo("/");
        setTimeout(() => {
          const postInput = document.querySelector(".input-container textarea");
          if (postInput) postInput.focus();
        }, 300);
        break;
      case "reel":
        // To be implemented
        alert("Reels creation coming soon!");
        break;
    }
  }

  onMount(() => {
    document.addEventListener("click", handleDocumentClick);
  });

  onDestroy(() => {
    document.removeEventListener("click", handleDocumentClick);
  });
</script>

<nav class="bottom-nav">
  <button
    class="nav-item"
    class:active={activeTab === "home"}
    on:click={() => navigateTo("/")}
  >
    <div class="nav-icon">
      <svg
        width="24"
        height="24"
        viewBox="0 0 24 24"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
      >
        <path
          d="M3 9L12 2L21 9V20C21 20.5304 20.7893 21.0391 20.4142 21.4142C20.0391 21.7893 19.5304 22 19 22H5C4.46957 22 3.96086 21.7893 3.58579 21.4142C3.21071 21.0391 3 20.5304 3 20V9Z"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
        />
        <path
          d="M9 22V12H15V22"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
        />
      </svg>
    </div>
    <div class="nav-text">Home</div>
  </button>

  <button
    class="nav-item"
    class:active={activeTab === "discover"}
    on:click={() => navigateTo("/discover")}
  >
    <div class="nav-icon">
      <svg
        width="24"
        height="24"
        viewBox="0 0 24 24"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
      >
        <circle
          cx="12"
          cy="12"
          r="10"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
        />
        <path
          d="M14.31 8L20.05 17.94"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
        />
        <path
          d="M9.69 8H21.17"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
        />
        <path
          d="M7.38 12.0001L13.12 2.06006"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
        />
        <path
          d="M9.69 16.0001L3.95 6.06006"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
        />
        <path
          d="M14.31 16H2.83"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
        />
        <path
          d="M16.62 12L10.88 21.94"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
        />
      </svg>
    </div>
    <div class="nav-text">Discover</div>
  </button>

  <div class="nav-item-center">
    <button class="action-button" on:click={toggleCreateMenu}>
      <div class="plus-icon">+</div>
    </button>
    <div class="nav-text create-text">Create</div>

    {#if showCreateMenu}
      <div class="create-menu">
        <button class="menu-item" on:click={() => handleAction("story")}>
          <div class="menu-icon story-icon">📸</div>
          <span>Story</span>
        </button>
        <button class="menu-item" on:click={() => handleAction("post")}>
          <div class="menu-icon post-icon">📝</div>
          <span>Post</span>
        </button>
        <button class="menu-item" on:click={() => handleAction("task")}>
          <div class="menu-icon task-icon">✓</div>
          <span>Task</span>
        </button>
        <button class="menu-item" on:click={() => handleAction("challenge")}>
          <div class="menu-icon challenge-icon">🏆</div>
          <span>Challenge</span>
        </button>
        <button class="menu-item" on:click={() => handleAction("reel")}>
          <div class="menu-icon reel-icon">🎬</div>
          <span>Reel</span>
        </button>
      </div>
    {/if}
  </div>

  <button
    class="nav-item"
    class:active={activeTab === "notifications"}
    on:click={() => navigateTo("/notifications")}
  >
    <div class="nav-icon">
      <svg
        width="24"
        height="24"
        viewBox="0 0 24 24"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
      >
        <path
          d="M18 8C18 6.4087 17.3679 4.88258 16.2426 3.75736C15.1174 2.63214 13.5913 2 12 2C10.4087 2 8.88258 2.63214 7.75736 3.75736C6.63214 4.88258 6 6.4087 6 8C6 15 3 17 3 17H21C21 17 18 15 18 8Z"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
        />
        <path
          d="M13.73 21C13.5542 21.3031 13.3019 21.5547 12.9982 21.7295C12.6946 21.9044 12.3504 21.9965 12 21.9965C11.6496 21.9965 11.3054 21.9044 11.0018 21.7295C10.6982 21.5547 10.4458 21.3031 10.27 21"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
        />
      </svg>
      {#if notificationCount > 0}
        <span class="notification-badge"
          >{notificationCount > 99 ? "99+" : notificationCount}</span
        >
      {/if}
    </div>
    <div class="nav-text">Alerts</div>
  </button>

  <button
    class="nav-item"
    class:active={activeTab === "profile"}
    on:click={() => navigateTo("/profile")}
  >
    <div class="nav-icon">
      <svg
        width="24"
        height="24"
        viewBox="0 0 24 24"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
      >
        <path
          d="M20 21V19C20 17.9391 19.5786 16.9217 18.8284 16.1716C18.0783 15.4214 17.0609 15 16 15H8C6.93913 15 5.92172 15.4214 5.17157 16.1716C4.42143 16.9217 4 17.9391 4 19V21"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
        />
        <path
          d="M12 11C14.2091 11 16 9.20914 16 7C16 4.79086 14.2091 3 12 3C9.79086 3 8 4.79086 8 7C8 9.20914 9.79086 11 12 11Z"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
        />
      </svg>
    </div>
    <div class="nav-text">Profile</div>
  </button>
</nav>

<style>
  .bottom-nav {
    position: fixed;
    bottom: 0;
    left: 0;
    right: 0;
    height: 60px;
    background-color: white;
    display: flex;
    justify-content: space-around;
    align-items: center;
    box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.1);
    z-index: 100;
  }

  .nav-item {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    background: none;
    border: none;
    color: var(--gray);
    padding: 8px 0;
    position: relative;
    transition: color 0.2s ease;
    cursor: pointer;
    height: 100%;
  }

  .nav-item:hover {
    color: var(--charcoal);
  }

  .nav-item.active {
    color: var(--tomato);
  }

  .nav-icon {
    position: relative;
    margin-bottom: 4px;
  }

  /* Ultra strong text styling to override any global styles */
  .nav-text {
    font-size: 12px !important;
    font-weight: 600 !important;
    display: block !important;
    visibility: visible !important;
    color: #2f4858 !important; /* Using the actual color code instead of var */
    margin-top: 4px !important;
    text-align: center !important;
    line-height: 1 !important;
    opacity: 1 !important;
  }

  /* Special style for active item text */
  .nav-item.active .nav-text {
    color: #f26440 !important; /* Using the actual color code instead of var */
  }

  .create-text {
    position: absolute !important;
    bottom: 2px !important;
    left: 0 !important;
    right: 0 !important;
    text-align: center !important;
    color: #f26440 !important; /* Using the actual color code instead of var */
    font-weight: 600 !important;
  }

  .notification-badge {
    position: absolute;
    top: -5px;
    right: -8px;
    background-color: var(--tomato);
    color: white;
    font-size: 10px;
    font-weight: bold;
    min-width: 16px;
    height: 16px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0 4px;
  }

  .nav-item-center {
    position: relative;
    height: 60px;
    width: 60px;
    display: flex;
    flex-direction: column;
    align-items: center;
  }

  /* Special styling for the center action button */
  .action-button {
    margin-top: -25px; /* Pull up to overlap with bottom nav */
    width: 60px;
    height: 60px;
    border-radius: 50%;
    background-color: var(--tomato);
    border: 4px solid white;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0;
    transform: scale(1);
    transition:
      transform 0.2s ease,
      background-color 0.2s ease;
    cursor: pointer;
    z-index: 101;
    position: absolute;
    top: -30px;
  }

  .action-button:hover,
  .action-button:active {
    transform: scale(1.05);
    background-color: var(--tomato-light);
  }

  .plus-icon {
    font-size: 28px;
    font-weight: bold;
    margin-top: -2px; /* Visual alignment */
  }

  /* Create menu styling */
  .create-menu {
    position: absolute;
    bottom: 70px;
    left: 50%;
    transform: translateX(-50%);
    background-color: white;
    border-radius: 12px;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.15);
    padding: 8px;
    width: 280px;
    display: flex;
    flex-direction: column;
    z-index: 100;
  }

  .menu-item {
    display: flex;
    align-items: center;
    padding: 12px;
    border: none;
    background: none;
    border-radius: 8px;
    cursor: pointer;
    transition: background-color 0.2s;
    text-align: left;
  }

  .menu-item:hover {
    background-color: var(--light-gray);
  }

  .menu-item span {
    color: #2f4858 !important; /* Dark charcoal color */
    font-weight: 600 !important;
    font-size: 14px !important;
  }

  .menu-icon {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: 12px;
    font-size: 20px;
  }

  .story-icon {
    background-color: #e91e63;
    color: white;
  }

  .post-icon {
    background-color: #2196f3;
    color: white;
  }

  .task-icon {
    background-color: #4caf50;
    color: white;
  }

  .challenge-icon {
    background-color: #ff9800;
    color: white;
  }

  .reel-icon {
    background-color: #9c27b0;
    color: white;
  }
</style>
