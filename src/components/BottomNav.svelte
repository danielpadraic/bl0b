<script>
  import { showTaskCompletionForm } from "../stores.js";

  // Props
  export let activeTab = "home";
  export let notificationCount = 0;

  // Handle navigation
  function navigateTo(route) {
    // Use the custom navigation function added to the window object
    if (window.navigateTo) {
      window.navigateTo(route);
    } else {
      // Fallback to simple location change if navigateTo isn't available
      window.location.href = route;
    }
  }

  // Show task completion form
  function showTaskForm() {
    showTaskCompletionForm.set(true);
  }
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
    <span class="nav-label">Home</span>
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
    <span class="nav-label">Discover</span>
  </button>

  <button class="nav-item action-button" on:click={showTaskForm}>
    <div class="plus-icon">+</div>
  </button>

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
    <span class="nav-label">Alerts</span>
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
    <span class="nav-label">Profile</span>
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

  .nav-label {
    font-size: 12px;
    font-weight: 500;
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

  /* Special styling for the center action button */
  .action-button {
    margin-top: -25px; /* Pull up to overlap with bottom nav */
    flex: 0 0 60px;
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
</style>
