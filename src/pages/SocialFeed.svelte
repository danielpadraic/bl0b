<script>
  import { onMount } from "svelte";
  import { user } from "../stores/user.js";
  import { supabase } from "../supabase.js";

  export let channel;
  let posts = [];
  let newPost = "";
  let loading = true;

  onMount(async () => {
    if (channel) {
      await fetchPosts();
    }
    loading = false;
  });

  $: if (channel) fetchPosts();

  async function fetchPosts() {
    const table =
      channel.type === "social"
        ? "social_channels"
        : channel.type === "group"
          ? "private_groups"
          : "challenge_lobbies";
    const { data } = await supabase
      .from("posts")
      .select("*, users(username)")
      .eq("channel_id", channel.id)
      .order("created_at", { ascending: false });
    posts = data || [];
  }

  async function submitPost() {
    if (!$user || !newPost.trim()) return;
    const { error } = await supabase.from("posts").insert({
      channel_id: channel.id,
      user_id: $user.id,
      content: newPost,
    });
    if (!error) {
      newPost = "";
      await fetchPosts();
    }
  }
</script>

<div class="social-feed">
  <h2>Social Feed</h2>
  {#if !channel}
    <p>Select a channel to view the feed.</p>
  {:else if loading}
    <p>Loading feed...</p>
  {:else}
    <section class="posts">
      {#each posts as post}
        <div class="post">
          <strong>@{post.users.username}</strong>
          <p>{post.content}</p>
          <small>{new Date(post.created_at).toLocaleString()}</small>
        </div>
      {/each}
      {#if posts.length === 0}
        <p>No posts yet. Be the first!</p>
      {/if}
    </section>
    {#if $user}
      <form on:submit|preventDefault={submitPost}>
        <textarea
          bind:value={newPost}
          placeholder="Post a message..."
          rows="3"
          disabled={!channel}
        ></textarea>
        <button type="submit" disabled={!newPost.trim()}>Post</button>
      </form>
    {:else}
      <p><a href="/signup">Sign up</a> to join the conversation!</p>
    {/if}
  {/if}
</div>

<style>
  .social-feed {
    padding: 1rem;
  }

  .posts {
    margin-bottom: 1rem;
    max-height: 50vh;
    overflow-y: auto;
  }

  .post {
    border-bottom: 1px solid var(--charcoal, #333);
    padding: 0.5rem 0;
  }

  textarea {
    width: 100%;
    padding: 0.5rem;
    margin-bottom: 0.5rem;
    border: 1px solid var(--charcoal, #333);
    border-radius: 4px;
  }

  button {
    background-color: var(--tomato, #ff6347);
    color: var(--white, #fff);
    border: none;
    padding: 0.5rem 1rem;
    border-radius: 4px;
    cursor: pointer;
  }

  button:disabled {
    background-color: var(--gray, #a9a9a9);
    cursor: not-allowed;
  }

  button:hover:not(:disabled) {
    background-color: var(--tomato-light, #ff8c69);
  }
</style>
