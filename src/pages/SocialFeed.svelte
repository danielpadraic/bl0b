<script>
  import { onMount, onDestroy } from "svelte";
  import { supabase } from "../supabase.js";
  import { user } from "../stores.js";

  export let challengeId;
  export let challengeName;

  let posts = [];
  let newPost = "";
  let mediaFiles = [];
  let replyingTo = null;
  let replyContent = "";
  let showEmojiPicker = false;
  let showTaskPicker = false;

  onMount(async () => {
    await fetchPosts();
    const channel = supabase
      .channel("public:posts")
      .on(
        "postgres_changes",
        {
          event: "INSERT",
          schema: "public",
          table: "posts",
          filter: `challenge_id=eq.${challengeId}`,
        },
        (payload) => {
          const newPost = {
            ...payload.new,
            timestamp: new Date(payload.new.created_at).toLocaleString(
              "en-US",
              { hour: "numeric", minute: "numeric", hour12: true }
            ),
            username: payload.new.username || "Unknown",
          };
          posts = [newPost, ...posts];
        }
      )
      .subscribe();
    return () => supabase.removeChannel(channel);
  });

  async function fetchPosts() {
    const { data, error } = await supabase
      .from("posts")
      .select("*")
      .eq("challenge_id", challengeId)
      .order("created_at", { ascending: false });
    if (error) {
      console.error("Error fetching posts:", error);
    } else {
      posts = data.map((post) => ({
        ...post,
        timestamp: new Date(post.created_at).toLocaleString("en-US", {
          hour: "numeric",
          minute: "numeric",
          hour12: true,
        }),
        username: post.username || "Unknown",
      }));
    }
  }

  async function uploadMedia(file) {
    const fileName = `${Date.now()}-${file.name}`;
    const { error } = await supabase.storage
      .from("media")
      .upload(fileName, file);
    if (error) throw error;
    return supabase.storage.from("media").getPublicUrl(fileName).data.publicUrl;
  }

  async function submitPost() {
    if (!newPost.trim() && mediaFiles.length === 0) return;
    let mediaUrls = [];
    if (mediaFiles.length > 0) {
      mediaUrls = await Promise.all(mediaFiles.map(uploadMedia));
    }
    const { data, error } = await supabase
      .from("posts")
      .insert([
        {
          challenge_id: challengeId,
          content: newPost,
          user_id: $user.id,
          username: $user.username || "Unknown",
          media_urls: mediaUrls,
          parent_id: null,
          created_at: new Date().toISOString(),
        },
      ])
      .select();
    if (error) {
      console.error("Error submitting post:", error);
    } else {
      posts = [
        {
          ...data[0],
          timestamp: new Date().toLocaleString("en-US", {
            hour: "numeric",
            minute: "numeric",
            hour12: true,
          }),
          username: $user.username || "Unknown",
        },
        ...posts,
      ];
      newPost = "";
      mediaFiles = [];
      showEmojiPicker = false;
    }
  }

  async function submitReply(parentId) {
    if (!replyContent.trim()) return;
    const { data, error } = await supabase
      .from("posts")
      .insert([
        {
          challenge_id: challengeId,
          content: replyContent,
          user_id: $user.id,
          username: $user.username || "Unknown",
          parent_id: parentId,
          created_at: new Date().toISOString(),
        },
      ])
      .select();
    if (error) {
      console.error("Error submitting reply:", error);
    } else {
      posts = [
        {
          ...data[0],
          timestamp: new Date().toLocaleString("en-US", {
            hour: "numeric",
            minute: "numeric",
            hour12: true,
          }),
          username: $user.username || "Unknown",
        },
        ...posts,
      ];
      replyContent = "";
      replyingTo = null;
    }
  }

  function handleMediaChange(event) {
    mediaFiles = Array.from(event.target.files);
    submitPost(); // Auto-submit after media selection
  }

  function addEmoji(emoji) {
    newPost += emoji;
    showEmojiPicker = false;
  }

  function toggleBold() {
    newPost = newPost.trim() ? `**${newPost}**` : newPost;
  }

  function toggleItalic() {
    newPost = newPost.trim() ? `_${newPost}_` : newPost;
  }

  function addList() {
    newPost += "\n- ";
  }

  function addLocation() {
    newPost += "📍 Location"; // Placeholder; enhance with actual geolocation if desired
  }

  async function completeTask() {
    // Placeholder: You'd fetch tasks and let user select one; for now, simulate with first task
    const { data: tasks } = await supabase
      .from("tasks")
      .select("action")
      .eq("challenge_id", challengeId)
      .limit(1);
    if (tasks && tasks.length > 0) {
      const taskName = tasks[0].action;
      newPost = `Completed task: ${taskName}`;
      await submitPost();
      showTaskPicker = false;
    }
  }
</script>

<div class="feed">
  <div class="post-form">
    <textarea bind:value={newPost} placeholder="Say something..." rows="2"
    ></textarea>
    <div class="toolbar">
      <button
        type="button"
        on:click={() => document.getElementById("mediaInput").click()}
        title="Image"
      >
        <span>🖼️</span>
      </button>
      <input
        id="mediaInput"
        type="file"
        multiple
        accept="image/*,video/*"
        on:change={handleMediaChange}
        hidden
      />
      <button type="button" on:click={() => (newPost += "GIF")} title="GIF">
        <span>🎞️</span>
      </button>
      <button type="button" on:click={addList} title="List">
        <span>📋</span>
      </button>
      <button
        type="button"
        on:click={() => (showEmojiPicker = !showEmojiPicker)}
        title="Emoji"
      >
        <span>😊</span>
      </button>
      <button type="button" on:click={addLocation} title="Location">
        <span>📍</span>
      </button>
      <button type="button" on:click={toggleBold} title="Bold">
        <span>𝐁</span>
      </button>
      <button type="button" on:click={toggleItalic} title="Italic">
        <span>𝐼</span>
      </button>
      <button
        type="button"
        on:click={() => (showTaskPicker = !showTaskPicker)}
        title="Complete Task"
      >
        <span>+""</span>
      </button>
      <button type="button" on:click={submitPost}>Post</button>
    </div>
    {#if showEmojiPicker}
      <div class="emoji-picker">
        {#each ["😊", "👍", "😂", "❤️", "🔥"] as emoji}
          <span on:click={() => addEmoji(emoji)}>{emoji}</span>
        {/each}
      </div>
    {/if}
    {#if showTaskPicker}
      <div class="task-picker">
        <button on:click={completeTask}>Complete a Task</button>
      </div>
    {/if}
  </div>

  {#each posts.filter((p) => !p.parent_id) as post}
    <div class="post">
      <p class="post-meta">
        {post.timestamp} | #{challengeName} | @{post.username}
      </p>
      <p class="post-content">{post.content}</p>
      {#if post.media_urls && post.media_urls.length > 0}
        <div class="media">
          {#each post.media_urls as url}
            {#if url.match(/\.(mp4|webm)$/i)}
              <video src={url} controls width="100%"></video>
            {:else}
              <img src={url} alt="Post media" />
            {/if}
          {/each}
        </div>
      {/if}
      <button
        class="reply-btn"
        on:click={() => (replyingTo = replyingTo === post.id ? null : post.id)}
      >
        Reply
      </button>
      {#if replyingTo === post.id}
        <div class="reply-form">
          <textarea bind:value={replyContent} placeholder="Reply..." rows="1"
          ></textarea>
          <button on:click={() => submitReply(post.id)}>Send</button>
        </div>
      {/if}
      {#each posts.filter((r) => r.parent_id === post.id) as reply}
        <div class="reply">
          <p class="post-meta">
            {reply.timestamp} | #{challengeName} | @{reply.username}
          </p>
          <p class="post-content">{reply.content}</p>
        </div>
      {/each}
    </div>
  {/each}
</div>

<style>
  .feed {
    max-height: 50vh; /* Reduced for mobile */
    overflow-y: auto;
    padding: 0.5rem;
    font-size: 0.9rem; /* Smaller font */
  }
  .post-form {
    margin-bottom: 0.5rem;
    display: flex;
    flex-direction: column;
    gap: 0.25rem;
  }
  .post-form textarea {
    width: 100%;
    resize: vertical;
    padding: 0.25rem;
    border: 1px solid var(--light-gray);
    border-radius: 4px;
    font-size: 0.85rem;
    min-height: 40px;
  }
  .toolbar {
    display: flex;
    gap: 0.25rem;
    flex-wrap: wrap;
  }
  .toolbar button {
    padding: 0.25rem;
    background: none;
    border: none;
    font-size: 1rem;
    cursor: pointer;
    color: var(--charcoal);
  }
  .toolbar button:hover {
    color: var(--tomato);
  }
  .emoji-picker,
  .task-picker {
    position: absolute;
    background: var(--white);
    border: 1px solid var(--light-gray);
    border-radius: 4px;
    padding: 0.5rem;
    z-index: 10;
  }
  .emoji-picker span {
    cursor: pointer;
    margin-right: 0.25rem;
  }
  .post {
    border-bottom: 1px solid #eee;
    padding: 0.5rem 0;
  }
  .post-meta {
    font-size: 0.75rem;
    color: var(--gray);
    margin: 0;
  }
  .post-content {
    font-size: 0.85rem;
    margin: 0.25rem 0;
  }
  .media img,
  .media video {
    max-width: 100%;
    margin-top: 0.25rem;
    border-radius: 4px;
  }
  .reply-btn {
    font-size: 0.75rem;
    padding: 0.2rem 0.5rem;
    background: none;
    color: var(--tomato);
  }
  .reply-form {
    margin-top: 0.25rem;
    display: flex;
    gap: 0.25rem;
  }
  .reply-form textarea {
    flex: 1;
    min-height: 30px;
  }
  .reply-form button {
    padding: 0.2rem 0.5rem;
    font-size: 0.75rem;
  }
  .reply {
    margin-left: 1rem;
    border-left: 1px solid #ccc;
    padding-left: 0.5rem;
  }
  @media (max-width: 600px) {
    .feed {
      padding: 0.25rem;
    }
    .post-form textarea {
      font-size: 0.8rem;
    }
    .toolbar button {
      font-size: 0.9rem;
    }
  }
</style>
