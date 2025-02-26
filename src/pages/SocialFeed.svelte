<script>
  import { supabase } from "../supabase.js";
  import { user } from "../stores/user.js";
  import { onMount } from "svelte";
  import { uploadFile } from "../utils/upload.js";
  import BottomNav from "../components/BottomNav.svelte";
  import { Fa } from "svelte-fa";
  import {
    faHome,
    faTrophy,
    faUsers,
    faPlus,
  } from "@fortawesome/free-solid-svg-icons";

  let posts = [];
  let loading = true;
  let showPostForm = false;
  let postContent = "";
  let postFile;

  onMount(async () => {
    const { data, error } = await supabase
      .from("posts")
      .select("*")
      .order("created_at", { ascending: false });
    if (!error) posts = data;
    loading = false;
  });

  async function createPost() {
    let mediaUrl = "";
    if (postFile) {
      const { Key } = await uploadFile(
        postFile,
        "post-media",
        `${Date.now()}-${postFile.name}`
      );
      mediaUrl = supabase.storage.from("post-media").getPublicUrl(Key)
        .data.publicUrl;
    }
    const { data, error } = await supabase.from("posts").insert([
      {
        content: postContent,
        media_url: mediaUrl,
        user_id: supabase.auth.user().id,
      },
    ]);
    if (!error) {
      posts = [data[0], ...posts];
      showPostForm = false;
      postContent = "";
      postFile = null;
    }
  }
</script>

<div class="social-feed">
  <h1>Social Feed</h1>
  <button class="fab" on:click={() => (showPostForm = !showPostForm)}>
    <Fa icon={faPlus} />
  </button>
  {#if showPostForm}
    <form on:submit|preventDefault={createPost}>
      <textarea
        bind:value={postContent}
        placeholder="What's on your mind?"
        required
      ></textarea>
      <input type="file" on:change={(e) => (postFile = e.target.files[0])} />
      <button type="submit">Post</button>
    </form>
  {/if}
  {#if loading}
    <p>Loading...</p>
  {:else}
    {#each posts as post}
      <div class="post">
        <p>{post.content}</p>
        {#if post.media_url}
          <img src={post.media_url} alt="Post media" width="100%" />
        {/if}
      </div>
    {/each}
  {/if}
</div>
<BottomNav activeTab="social" />

<style>
  .social-feed {
    padding: 20px;
    padding-bottom: 60px;
  }
  .fab {
    position: fixed;
    bottom: 70px;
    right: 20px;
    background-color: var(--tomato);
    color: white;
    border: none;
    border-radius: 50%;
    width: 50px;
    height: 50px;
    cursor: pointer;
  }
  .fab:hover {
    background-color: var(--hunyadi-yellow);
  }
  form {
    display: flex;
    flex-direction: column;
    gap: 10px;
    margin-bottom: 20px;
    border: 1px solid var(--charcoal);
    padding: 10px;
  }
  button {
    background-color: var(--tomato);
    color: white;
    border: none;
    padding: 10px;
    cursor: pointer;
  }
  .post {
    border: 1px solid var(--charcoal);
    padding: 10px;
    margin-bottom: 10px;
  }
  .post:hover {
    border-color: var(--lapis-lazuli);
  }
</style>
