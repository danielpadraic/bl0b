<script>
  import { navigate } from "svelte-routing";
</script>

<button
  class="create-challenge-btn"
  on:click={() => navigate("/create-challenge")}
>
  Create Challenge
</button>

<style>
  .create-challenge-btn {
    background-color: var(--tomato, #ff6347);
    color: var(--white, #fff);
    border: none;
    padding: 0.75rem 1.5rem;
    border-radius: 4px;
    font-weight: bold;
    cursor: pointer;
    position: relative;
    z-index: 5;
  }

  @media (max-width: 768px) {
    .create-challenge-btn {
      display: none; /* Hide on mobile; shown in hamburger menu */
    }
  }
</style>
