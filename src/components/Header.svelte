<script>
  export let menuOpen = false;
  export let currentUser = null;

  function toggleMenu() {
    menuOpen = !menuOpen;
    // Dispatch toggleMenu event using standard DOM event
    document.dispatchEvent(new CustomEvent("toggleMenu"));
  }

  function handleLogout() {
    // Dispatch logout event using standard DOM event
    document.dispatchEvent(new CustomEvent("logout"));
  }
</script>

<header class="app-header">
  <div class="header-content">
    <div class="logo">
      <span class="logo-text">bl0b</span>
    </div>

    <button class="menu-button" on:click={toggleMenu} aria-label="Toggle menu">
      <div class="menu-icon" class:active={menuOpen}>
        <span></span>
        <span></span>
        <span></span>
      </div>
    </button>
  </div>

  {#if menuOpen}
    <div
      class="menu-overlay"
      tabindex="0"
      role="button"
      on:click={toggleMenu}
      on:keydown={(e) => {
        if (e.key === "Enter" || e.key === "Space") {
          e.preventDefault();
          toggleMenu();
        }
      }}
    >
      <div
        class="menu-content"
        tabindex="0"
        role="menu"
        on:click|stopPropagation
        on:keydown={(e) => {
          if (e.key === "Enter" || e.key === "Space") {
            e.preventDefault();
            // No action needed for stopPropagation
          }
        }}
      >
        {#if currentUser}
          <button on:click={handleLogout}>Logout</button>
        {:else}
          <a href="/login">Login</a>
          <a href="/signup">Sign Up</a>
        {/if}
      </div>
    </div>
  {/if}
</header>

<style>
  /* Styles remain unchanged */
  .app-header {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    height: 60px;
    background-color: var(--charcoal);
    color: white;
    z-index: 100;
  }

  .header-content {
    display: flex;
    align-items: center;
    justify-content: space-between;
    height: 100%;
    padding: 0 16px;
  }

  .logo {
    font-weight: bold;
    font-size: 1.5rem;
  }

  .menu-button {
    background: none;
    border: none;
    padding: 8px;
    cursor: pointer;
    color: white;
  }

  .menu-icon {
    width: 24px;
    height: 18px;
    position: relative;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
  }

  .menu-icon span {
    display: block;
    height: 2px;
    width: 100%;
    background-color: white;
    border-radius: 2px;
    transition: all 0.3s ease;
  }

  .menu-icon.active span:nth-child(1) {
    transform: translateY(8px) rotate(45deg);
  }

  .menu-icon.active span:nth-child(2) {
    opacity: 0;
  }

  .menu-icon.active span:nth-child(3) {
    transform: translateY(-8px) rotate(-45deg);
  }

  .menu-overlay {
    position: fixed;
    top: 60px;
    right: 0;
    bottom: 0;
    width: 80%;
    max-width: 300px;
    background-color: white;
    box-shadow: -2px 0 10px rgba(0, 0, 0, 0.1);
    z-index: 99;
  }

  .menu-content {
    padding: 16px;
    display: flex;
    flex-direction: column;
    gap: 16px;
  }
</style>
