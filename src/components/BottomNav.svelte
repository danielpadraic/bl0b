<script>
  import { link } from "svelte-routing";
  import Fa from "svelte-fa";
  import { faHome, faTrophy, faUsers } from "@fortawesome/free-solid-svg-icons";

  export let activeTab;
</script>

<nav class="bottom-nav">
  <a href="/" use:link class={activeTab === "home" ? "active" : ""}>
    <Fa icon={faHome} size="lg" />
    <span>Home</span>
  </a>
  <a
    href="/leaderboards"
    use:link
    class={activeTab === "leaderboards" ? "active" : ""}
  >
    <Fa icon={faTrophy} size="lg" />
    <span>Leaderboards</span>
  </a>
  <a href="/social" use:link class={activeTab === "social" ? "active" : ""}>
    <Fa icon={faUsers} size="lg" />
    <span>Social</span>
  </a>
</nav>

<style>
  .bottom-nav {
    position: fixed;
    bottom: 0;
    left: 0;
    right: 0;
    display: flex;
    justify-content: space-around;
    background-color: var(--charcoal);
    padding: clamp(0.5rem, 2vw, 1rem) 0;
    z-index: 10;
  }

  a {
    color: var(--white);
    text-decoration: none;
    display: flex;
    flex-direction: column;
    align-items: center;
    font-size: clamp(0.8rem, 2vw, 1rem);
  }

  .active {
    color: var(--tomato);
  }

  a:hover {
    color: var(--tomato-light);
  }

  span {
    margin-top: clamp(0.2rem, 1vw, 0.5rem);
  }
</style>
