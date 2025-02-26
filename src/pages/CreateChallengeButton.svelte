<script>
  import { navigate } from "svelte-routing"; // Adjust if using SvelteKit routing
</script>

<button on:click={() => navigate("/create-challenge")}>
  Create Challenge
</button>

<style>
  button {
    background-color: var(--tomato, #ff6347);
    color: var(--white, #fff);
    border: none;
    padding: 0.75rem 1.5rem;
    border-radius: 4px;
    font-weight: bold;
    cursor: pointer;
  }

  button:hover {
    background-color: var(--tomato-light, #ff8c69);
  }
</style>
