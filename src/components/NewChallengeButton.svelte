<script>
  import { createEventDispatcher } from "svelte";

  export let size = "large"; // large, medium, small
  export let position = "bottom-right"; // can be bottom-right, bottom-center, etc.

  const dispatch = createEventDispatcher();

  function handleClick() {
    dispatch("click");
  }
</script>

<button
  class="new-challenge-button {size} {position}"
  on:click={handleClick}
  aria-label="Create new challenge"
>
  <div class="button-content">
    <span class="plus-icon">+</span>
    {#if size !== "small"}
      <span class="button-text">New Challenge</span>
    {/if}
  </div>
</button>

<style>
  .new-challenge-button {
    position: fixed;
    border: none;
    border-radius: 50px;
    background-color: var(--tomato);
    color: white;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
    cursor: pointer;
    z-index: 90;
    transition:
      transform 0.2s ease,
      background-color 0.2s ease;
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .new-challenge-button:hover,
  .new-challenge-button:active {
    background-color: var(--tomato-light);
    transform: translateY(-2px);
    box-shadow: 0 6px 15px rgba(0, 0, 0, 0.25);
  }

  .button-content {
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .plus-icon {
    font-size: 1.6rem;
    font-weight: bold;
    margin-right: 8px;
  }

  .button-text {
    font-weight: 600;
    font-size: 0.9rem;
  }

  /* Size variations */
  .large {
    padding: 12px 20px;
    height: 56px;
  }

  .medium {
    padding: 10px 16px;
    height: 48px;
  }

  .small {
    width: 48px;
    height: 48px;
    border-radius: 50%;
    padding: 0;
  }

  .small .plus-icon {
    margin-right: 0;
  }

  /* Position variations */
  .bottom-right {
    bottom: 80px; /* Above the bottom nav */
    right: 20px;
  }

  .bottom-center {
    bottom: 80px;
    left: 50%;
    transform: translateX(-50%);
  }

  .bottom-center:hover {
    transform: translateX(-50%) translateY(-2px);
  }
</style>
