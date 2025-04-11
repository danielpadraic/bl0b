<script>
  export let size = "medium"; // small, medium, large
  export let color = "var(--tomato)"; // Default to app primary color
  export let overlay = false; // Whether to show with a background overlay
</script>

<div
  class="spinner-container {overlay ? 'with-overlay' : ''}"
  aria-busy="true"
  aria-live="polite"
>
  <div class="spinner {size}" style="--spinner-color: {color}">
    <div class="spinner-inner"></div>
  </div>
  {#if $$slots.default}
    <div class="spinner-text">
      <slot></slot>
    </div>
  {/if}
</div>

<style>
  .spinner-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 20px;
  }

  .spinner-container.with-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(255, 255, 255, 0.8);
    z-index: 1000;
  }

  .spinner {
    position: relative;
  }

  .spinner.small {
    width: 24px;
    height: 24px;
  }

  .spinner.medium {
    width: 40px;
    height: 40px;
  }

  .spinner.large {
    width: 64px;
    height: 64px;
  }

  .spinner-inner {
    position: absolute;
    border: 3px solid transparent;
    border-radius: 50%;
    border-top-color: var(--spinner-color);
    animation: spin 1s linear infinite;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
  }

  .spinner.small .spinner-inner {
    border-width: 2px;
  }

  .spinner.large .spinner-inner {
    border-width: 4px;
  }

  @keyframes spin {
    0% {
      transform: rotate(0deg);
    }
    100% {
      transform: rotate(360deg);
    }
  }

  .spinner-text {
    margin-top: 16px;
    color: var(--charcoal);
    font-size: 14px;
    text-align: center;
  }
</style>
