<script>
  import { navigate } from "svelte-routing";
  import Fa from "svelte-fa";
  import {
    faHome,
    faTrophy,
    faUsers,
    faNewspaper,
  } from "@fortawesome/free-solid-svg-icons";
  import { showTaskCompletionForm } from "../stores.js";

  export let activeTab;

  function goTo(route) {
    navigate(route);
  }
</script>

<nav class="bottom-nav">
  <button
    on:click={() => goTo("/")}
    class={activeTab === "home" ? "active" : ""}
  >
    <Fa icon={faHome} size="lg" />
    <span>Home</span>
  </button>
  <button
    on:click={() => goTo("/leaderboards")}
    class={activeTab === "leaderboards" ? "active" : ""}
  >
    <Fa icon={faTrophy} size="lg" />
    <span>Leaderboards</span>
  </button>
  <button
    class="task-complete-btn"
    on:click={() => showTaskCompletionForm.set(true)}
  >
    <span>+</span>
  </button>
  <button
    on:click={() => goTo("/social")}
    class={activeTab === "social" ? "active" : ""}
  >
    <Fa icon={faUsers} size="lg" />
    <span>Social</span>
  </button>
  <button
    on:click={() => goTo("/news")}
    class={activeTab === "news" ? "active" : ""}
  >
    <Fa icon={faNewspaper} size="lg" />
    <span>News</span>
  </button>
</nav>

<style>
  .bottom-nav {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background-color: var(--charcoal);
    padding: 10px;
    position: fixed;
    bottom: 0;
    width: 100%;
    max-width: 500px;
    left: 50%;
    transform: translateX(-50%);
    z-index: 1000;
  }

  button {
    background: none;
    border: none;
    color: var(--carolina-blue);
    display: flex;
    flex-direction: column;
    align-items: center;
    font-size: 0.8rem;
    cursor: pointer;
    padding: 0;
    flex: 1;
  }

  .active {
    color: var(--tomato);
  }

  span {
    margin-top: 5px;
  }

  .task-complete-btn {
    background-color: var(--tomato);
    color: var(--white);
    border-radius: 8px;
    width: 50px;
    height: 50px;
    font-size: 1.5rem;
    justify-content: center;
    align-items: center;
    position: relative;
    z-index: 1;
    flex: 0.5;
  }

  .task-complete-btn:hover {
    background-color: var(--tomato-light);
  }
</style>
