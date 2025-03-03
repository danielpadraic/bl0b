<script>
  import { onMount, onDestroy } from "svelte";
  import { showTaskCompletionForm, showChallengeCreation } from "../stores.js";

  // Prop to control whether the menu appears above or below the button
  export let menuPosition = "below"; // 'above' or 'below'
  export let buttonWidth = "40px";
  export let buttonHeight = "40px";

  let isMenuOpen = false;
  let buttonElement;
  let menuElement;

  // Toggle the menu visibility
  function toggleMenu() {
    isMenuOpen = !isMenuOpen;
  }

  // Handle clicks on menu options
  function handleOptionClick(action) {
    if (action === "completeTask") {
      showTaskCompletionForm.set(true);
    } else if (action === "createChallenge") {
      showChallengeCreation.set(true);
    }
    isMenuOpen = false;
  }

  // Close the menu if clicking outside
  function handleDocumentClick(event) {
    if (buttonElement && menuElement) {
      if (
        !buttonElement.contains(event.target) &&
        !menuElement.contains(event.target)
      ) {
        isMenuOpen = false;
      }
    }
  }

  onMount(() => {
    document.addEventListener("click", handleDocumentClick);
  });

  onDestroy(() => {
    document.removeEventListener("click", handleDocumentClick);
  });
</script>

<div class="task-button-with-menu">
  <button
    class="task-complete-btn"
    style="width: {buttonWidth}; height: {buttonHeight};"
    on:click={toggleMenu}
    bind:this={buttonElement}
  >
    <span>+</span>
  </button>
  {#if isMenuOpen}
    <div
      class="menu"
      class:above={menuPosition === "above"}
      class:below={menuPosition === "below"}
      bind:this={menuElement}
    >
      <button
        class="menu-btn"
        on:click={() => handleOptionClick("completeTask")}
      >
        Complete a Task
      </button>
      <button
        class="menu-btn"
        on:click={() => handleOptionClick("createChallenge")}
      >
        Create a Challenge
      </button>
    </div>
  {/if}
</div>

<style>
  .task-button-with-menu {
    position: relative;
    display: inline-block;
  }

  .task-complete-btn {
    background-color: var(--tomato);
    color: var(--white);
    border: none;
    border-radius: 8px;
    font-size: 1.5rem;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
  }

  .task-complete-btn:hover {
    background-color: var(--tomato-light);
  }

  .menu {
    position: absolute;
    background-color: var(--white);
    border: 1px solid var(--light-gray);
    padding: 10px;
    z-index: 100;
    display: flex;
    flex-direction: row; /* Options appear side by side */
    gap: 10px; /* Space between buttons */
    left: 50%;
    transform: translateX(
      -50%
    ); /* Center horizontally relative to the + button */
  }

  .menu.below {
    top: 100%; /* Menu appears below the button */
  }

  .menu.above {
    bottom: 100%; /* Menu appears above the button */
  }

  .menu-btn {
    background-color: var(--tomato);
    color: var(--white);
    border: none;
    padding: 10px 20px;
    border-radius: 4px;
    cursor: pointer;
    font-size: 1rem;
    white-space: nowrap; /* Prevent text wrapping */
  }

  .menu-btn:hover {
    background-color: var(--tomato-light);
  }
</style>
