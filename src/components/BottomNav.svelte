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
    background-color: #333;
    padding: 10px 0;
    z-index: 10;
  }

  a {
    color: white;
    text-decoration: none;
    display: flex;
    flex-direction: column;
    align-items: center;
    font-size: 0.9rem;
  }

  .active {
    color: #ff6347;
  }

  a:hover {
    color: #ff6347;
  }

  span {
    margin-top: 5px;
  }
</style>
