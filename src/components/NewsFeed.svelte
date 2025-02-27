<script>
  import { onMount } from "svelte";
  import { supabase } from "../supabase.js";

  let newsItems = [];
  let loading = true;
  let error = null;

  onMount(async () => {
    await fetchNews();
  });

  async function fetchNews() {
    try {
      const { data, error: fetchError } = await supabase
        .from("news_feed")
        .select("*")
        .order("created_at", { ascending: false });

      if (fetchError) throw fetchError;

      newsItems = data;
      loading = false;
    } catch (err) {
      error = err.message;
      loading = false;
    }
  }
</script>

<div class="news-feed">
  <h3>News Feed</h3>
  {#if loading}
    <p>Loading...</p>
  {:else if error}
    <p class="error">Error: {error}</p>
  {:else}
    <ul>
      {#each newsItems as item}
        <li>{item.message}</li>
      {/each}
    </ul>
  {/if}
</div>

<style>
  .news-feed {
    padding: 1rem;
    background-color: var(--light-gray);
    border-radius: 8px;
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
  }

  h3 {
    margin: 0 0 1rem 0;
    font-size: 1.1rem;
    color: var(--charcoal);
  }

  ul {
    list-style: none;
    padding: 0;
  }

  li {
    margin-bottom: 0.5rem;
    font-size: 0.85rem;
    color: var(--charcoal);
    transition: color 0.3s;
  }

  li:hover {
    color: var(--tomato);
  }

  .error {
    color: var(--tomato);
  }
</style>
