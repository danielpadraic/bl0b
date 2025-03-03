<script>
  import { onMount, onDestroy } from "svelte";
  import { supabase } from "../supabase.js";
  import { user } from "../stores.js";

  export let challengeId;
  export let challengeName;

  let posts = [];
  let newPost = "";
  let mediaFiles = [];
  let showEmojiPicker = false;
  let showGifPicker = false;
  let gifs = [];
  let gifSearch = "";
  let participants = [];
  let showTagPicker = false;
  let tagSuggestions = [];
  let tagStartIndex = -1;
  let currentUserUsername = "";
  let showReactionPicker = null;
  let replyingTo = null; // Track the post ID being replied to
  let replyContent = ""; // Content for the current reply
  let minimized = false;

  const GIPHY_API_KEY = "lGJJOnOXxAtmYy5GaKCId3RDdah90xaG";

  onMount(async () => {
    await fetchCurrentUserUsername();
    await fetchPosts();
    await fetchParticipants();
    const channel = supabase
      .channel(`public:posts:challenge_id=eq.${challengeId}`)
      .on(
        "postgres_changes",
        {
          event: "INSERT",
          schema: "public",
          table: "posts",
          filter: `challenge_id=eq.${challengeId}`,
        },
        (payload) => {
          console.log("New post received via subscription:", payload.new);
          const newPost = {
            ...payload.new,
            timestamp: new Date(payload.new.created_at).toLocaleString(
              "en-US",
              {
                hour: "numeric",
                minute: "numeric",
                hour12: true,
              }
            ),
            username: payload.new.username || "Unknown",
            reactions: [],
          };
          posts = [newPost, ...posts];
          console.log("Updated posts array after subscription:", posts);
        }
      )
      .subscribe((status) => {
        console.log("Subscription status:", status);
      });
    return () => supabase.removeChannel(channel);
  });

  onDestroy(() => {
    console.log("SocialFeed destroyed, cleaning up subscription");
  });

  async function fetchCurrentUserUsername() {
    const { data, error } = await supabase
      .from("profiles")
      .select("username")
      .eq("id", $user.id)
      .single();
    if (error) {
      console.error("Error fetching username:", error);
    } else {
      currentUserUsername = data.username || "Unknown";
      console.log("Fetched current user username:", currentUserUsername);
    }
  }

  async function fetchPosts() {
    try {
      const { data, error: fetchError } = await supabase
        .from("posts")
        .select("*, post_reactions(reaction_type, user_id, profiles(username))")
        .eq("challenge_id", challengeId)
        .order("created_at", { ascending: false });
      if (fetchError) throw fetchError;
      posts = data.map((post) => ({
        ...post,
        timestamp: new Date(post.created_at).toLocaleString("en-US", {
          hour: "numeric",
          minute: "numeric",
          hour12: true,
        }),
        username: post.username || "Unknown",
        reactions: post.post_reactions || [],
      }));
      console.log("Fetched posts:", posts);
    } catch (err) {
      console.error("Error fetching posts:", err);
    }
  }

  async function fetchParticipants() {
    try {
      const { data, error } = await supabase
        .from("challenge_participants")
        .select("user_id, profiles(username)")
        .eq("challenge_id", challengeId);
      if (error) {
        console.error("Error fetching participants:", error);
        // Fallback: Try fetching usernames directly from profiles if relationship fails
        const { data: fallbackData, error: fallbackError } = await supabase
          .from("profiles")
          .select("username")
          .in(
            "id",
            (
              await supabase
                .from("challenge_participants")
                .select("user_id")
                .eq("challenge_id", challengeId)
            ).data.map((p) => p.user_id)
          );
        if (fallbackError) {
          console.error("Fallback error fetching participants:", fallbackError);
          participants = [];
        } else {
          participants = fallbackData.map((p) => p.username).filter(Boolean);
        }
      } else {
        participants = data.map((p) => p.profiles.username).filter(Boolean);
      }
      console.log("Fetched participants:", participants);
    } catch (err) {
      console.error("Unexpected error fetching participants:", err);
      participants = [];
    }
  }

  async function uploadMedia(fileOrUrl) {
    if (typeof fileOrUrl === "string") return fileOrUrl;
    if (fileOrUrl && typeof fileOrUrl === "object" && fileOrUrl.url)
      return fileOrUrl.url;
    const fileName = `${Date.now()}-${fileOrUrl.name}`;
    const { error } = await supabase.storage
      .from("media")
      .upload(fileName, fileOrUrl);
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
          username: currentUserUsername,
          media_urls: mediaUrls,
          parent_id: null,
          created_at: new Date().toISOString(),
        },
      ])
      .select();
    if (error) {
      console.error("Error submitting post:", error);
    } else {
      console.log("Manual post inserted:", data);
      newPost = "";
      mediaFiles = [];
      showEmojiPicker = false;
      showGifPicker = false;
      showTagPicker = false;
    }
  }

  async function submitReply(postId) {
    if (!replyContent.trim()) return;
    const parentPost = posts.find((p) => p.id === postId);
    const parentUsername = parentPost ? parentPost.username : null;
    const finalContent = parentUsername
      ? `@${parentUsername} ${replyContent}`
      : replyContent;
    const { data, error } = await supabase
      .from("posts")
      .insert([
        {
          challenge_id: challengeId,
          content: finalContent,
          user_id: $user.id,
          username: currentUserUsername,
          parent_id: postId,
          created_at: new Date().toISOString(),
        },
      ])
      .select();
    if (error) {
      console.error("Error submitting reply:", error);
    } else {
      console.log("Reply inserted:", data);
      replyContent = "";
      replyingTo = null;
      showEmojiPicker = false;
      showGifPicker = false;
      showTagPicker = false; // Reset pickers after submission
      await fetchPosts(); // Manually refresh posts to ensure UI updates
    }
  }

  async function toggleReaction(postId, reactionType) {
    const existingReaction = posts
      .find((p) => p.id === postId)
      .reactions.find(
        (r) => r.user_id === $user.id && r.reaction_type === reactionType
      );
    if (existingReaction) {
      const { error } = await supabase
        .from("post_reactions")
        .delete()
        .eq("post_id", postId)
        .eq("user_id", $user.id)
        .eq("reaction_type", reactionType);
      if (error) console.error("Error removing reaction:", error);
    } else {
      const { error } = await supabase
        .from("post_reactions")
        .insert([
          { post_id: postId, user_id: $user.id, reaction_type: reactionType },
        ]);
      if (error) console.error("Error adding reaction:", error);
    }
    await fetchPosts(); // Refresh posts after reaction update
    showReactionPicker = null;
  }

  function handleMediaChange(event) {
    mediaFiles = Array.from(event.target.files);
    submitPost();
  }

  async function searchGifs() {
    if (!gifSearch.trim()) {
      gifs = [];
      return;
    }
    const response = await fetch(
      `https://api.giphy.com/v1/gifs/search?api_key=${GIPHY_API_KEY}&q=${encodeURIComponent(gifSearch)}&limit=10`
    );
    const data = await response.json();
    gifs = data.data.map((gif) => ({
      id: gif.id,
      url: gif.images.fixed_height.url,
    }));
  }

  function addGif(gifUrl) {
    mediaFiles = [{ name: "gif", url: gifUrl }];
    submitPost();
  }

  function addEmoji(emoji) {
    if (replyingTo) {
      replyContent += emoji;
    } else {
      newPost += emoji;
    }
    showEmojiPicker = false;
  }

  function handleInput(event) {
    const value = replyingTo ? replyContent : newPost;
    const cursorPos = event.target.selectionStart;
    const lastAtIndex = value.lastIndexOf("@", cursorPos - 1);

    if (
      lastAtIndex !== -1 &&
      (cursorPos === lastAtIndex + 1 ||
        !value.slice(lastAtIndex + 1, cursorPos).includes(" "))
    ) {
      showTagPicker = true;
      tagStartIndex = lastAtIndex;
      const searchTerm = value.slice(lastAtIndex + 1, cursorPos).toLowerCase();
      tagSuggestions = participants
        .filter((username) => username.toLowerCase().startsWith(searchTerm))
        .slice(0, 5);
    } else {
      showTagPicker = false;
      tagStartIndex = -1;
      tagSuggestions = [];
    }
  }

  function handleKeydown(event, postId) {
    if ((event.ctrlKey || event.metaKey) && event.key === "Enter") {
      event.preventDefault();
      if (postId) {
        submitReply(postId);
      } else {
        submitPost();
      }
    }
  }

  function addTag(username) {
    const value = replyingTo ? replyContent : newPost;
    const before = value.slice(0, tagStartIndex);
    const after = value.slice(
      value.indexOf(" ", tagStartIndex) !== -1
        ? value.indexOf(" ", tagStartIndex)
        : value.length
    );
    if (replyingTo) {
      replyContent = `${before}@${username} ${after}`.trim();
    } else {
      newPost = `${before}@${username} ${after}`.trim();
    }
    showTagPicker = false;
    tagStartIndex = -1;
    tagSuggestions = [];
  }

  function tagUser(postId, username) {
    replyingTo = postId;
    replyContent = `@${username} `;
    setTimeout(() => {
      const textarea = document.querySelector(`#reply-${postId} textarea`);
      if (textarea) textarea.focus();
    }, 0);
  }

  function handleKeyPress(event, action) {
    if (event.key === "Enter" || event.key === " ") {
      event.preventDefault();
      action();
    }
  }

  function toggleMinimize() {
    minimized = !minimized;
    if (!minimized) {
      showEmojiPicker = false;
      showGifPicker = false;
      showTagPicker = false;
    }
  }

  function toggleReply(postId) {
    console.log(
      "Toggling reply for post:",
      postId,
      "current replyingTo:",
      replyingTo
    );
    replyingTo = replyingTo === postId ? null : postId;
    if (replyingTo) {
      replyContent = "";
      setTimeout(() => {
        const textarea = document.querySelector(`#reply-${postId} textarea`);
        if (textarea) {
          textarea.focus();
          console.log("Focused textarea for post:", postId);
        } else {
          console.error("Textarea not found for post:", postId);
        }
      }, 0);
    } else {
      console.log("Hiding reply form for post:", postId);
    }
  }

  function renderReplies(posts, parentId = null) {
    return posts
      .filter((p) => p.parent_id === parentId)
      .map((post) => ({
        post,
        replies: renderReplies(posts, post.id),
      }));
  }
</script>

<div class="feed-container">
  <div class="feed">
    {#each renderReplies(posts) as { post, replies }}
      <div class="post" class:reply={!!post.parent_id}>
        <p class="post-meta">
          {post.timestamp} |
          <span class="challenge-name">#{challengeName}</span>
          |
          <span
            class="username"
            role="button"
            tabindex="0"
            on:click={() => tagUser(post.id, post.username)}
            on:keydown={(e) =>
              handleKeyPress(e, () => tagUser(post.id, post.username))}
          >
            @{post.username}
          </span>
        </p>
        <p class="post-content">{post.content}</p>
        {#if post.media_urls && post.media_urls.length > 0}
          <div class="media">
            {#each post.media_urls as url}
              {#if url.match(/\.(mp4|webm)$/i)}
                <video src={url} controls width="100%">
                  <track kind="captions" label="No captions available" />
                </video>
              {:else}
                <img src={url} alt="Post media" />
              {/if}
            {/each}
          </div>
        {/if}
        <div class="reactions">
          <button
            class="reaction-btn"
            on:click={() =>
              (showReactionPicker =
                showReactionPicker === post.id ? null : post.id)}
          >
            🙂➕
          </button>
          {#if showReactionPicker === post.id}
            <div class="reaction-picker">
              <button on:click={() => toggleReaction(post.id, "like")}
                >👍</button
              >
              <button on:click={() => toggleReaction(post.id, "heart")}
                >❤️</button
              >
              <button on:click={() => toggleReaction(post.id, "laugh")}
                >😂</button
              >
              <button on:click={() => toggleReaction(post.id, "cry")}>😢</button
              >
              <button on:click={() => toggleReaction(post.id, "comfort")}
                >🤗</button
              >
            </div>
          {/if}
          {#each ["like", "heart", "laugh", "cry", "comfort"] as type}
            {#if post.reactions.some((r) => r.reaction_type === type)}
              <span
                class="reaction-count"
                title={post.reactions
                  .filter((r) => r.reaction_type === type)
                  .map((r) => r.profiles.username)
                  .join(", ")}
              >
                {type === "like"
                  ? "👍"
                  : type === "heart"
                    ? "❤️"
                    : type === "laugh"
                      ? "😂"
                      : type === "cry"
                        ? "😢"
                        : "🤗"}
                +{post.reactions.filter((r) => r.reaction_type === type).length}
              </span>
            {/if}
          {/each}
          <a
            href="#comment"
            class="comment-link"
            on:click|preventDefault={(e) => {
              console.log("Comment link clicked for post:", post.id);
              toggleReply(post.id);
            }}
          >
            Comment
          </a>
        </div>
        {#if replyingTo === post.id}
          <div class="reply-form active" id="reply-{post.id}">
            <textarea
              bind:value={replyContent}
              on:input={handleInput}
              on:keydown={(e) => handleKeydown(e, post.id)}
              placeholder="Reply..."
              rows="1"
            ></textarea>
            <button class="send-btn" on:click={() => submitReply(post.id)}
              >➤</button
            >
          </div>
        {/if}
        {#each replies as { post: replyPost, replies: nestedReplies }}
          <div class="reply">
            <p class="post-meta">
              {replyPost.timestamp} |
              <span class="challenge-name">#{challengeName}</span>
              |
              <span
                class="username"
                role="button"
                tabindex="0"
                on:click={() => tagUser(replyPost.id, replyPost.username)}
                on:keydown={(e) =>
                  handleKeyPress(e, () =>
                    tagUser(replyPost.id, replyPost.username)
                  )}
              >
                @{replyPost.username}
              </span>
            </p>
            <p class="post-content">{replyPost.content}</p>
            {#if replyPost.media_urls && replyPost.media_urls.length > 0}
              <div class="media">
                {#each replyPost.media_urls as url}
                  {#if url.match(/\.(mp4|webm)$/i)}
                    <video src={url} controls width="100%">
                      <track kind="captions" label="No captions available" />
                    </video>
                  {:else}
                    <img src={url} alt="Reply media" />
                  {/if}
                {/each}
              </div>
            {/if}
            <div class="reactions">
              <button
                class="reaction-btn"
                on:click={() =>
                  (showReactionPicker =
                    showReactionPicker === replyPost.id ? null : replyPost.id)}
              >
                🙂➕
              </button>
              {#if showReactionPicker === replyPost.id}
                <div class="reaction-picker">
                  <button on:click={() => toggleReaction(replyPost.id, "like")}
                    >👍</button
                  >
                  <button on:click={() => toggleReaction(replyPost.id, "heart")}
                    >❤️</button
                  >
                  <button on:click={() => toggleReaction(replyPost.id, "laugh")}
                    >😂</button
                  >
                  <button on:click={() => toggleReaction(replyPost.id, "cry")}
                    >😢</button
                  >
                  <button
                    on:click={() => toggleReaction(replyPost.id, "comfort")}
                    >🤗</button
                  >
                </div>
              {/if}
              {#each ["like", "heart", "laugh", "cry", "comfort"] as type}
                {#if replyPost.reactions.some((r) => r.reaction_type === type)}
                  <span
                    class="reaction-count"
                    title={replyPost.reactions
                      .filter((r) => r.reaction_type === type)
                      .map((r) => r.profiles.username)
                      .join(", ")}
                  >
                    {type === "like"
                      ? "👍"
                      : type === "heart"
                        ? "❤️"
                        : type === "laugh"
                          ? "😂"
                          : type === "cry"
                            ? "😢"
                            : "🤗"}
                    +{replyPost.reactions.filter(
                      (r) => r.reaction_type === type
                    ).length}
                  </span>
                {/if}
              {/each}
              <a
                href="#comment"
                class="comment-link"
                on:click|preventDefault={(e) => {
                  console.log("Comment link clicked for reply:", replyPost.id);
                  toggleReply(replyPost.id);
                }}
              >
                Comment
              </a>
            </div>
            {#if replyingTo === replyPost.id}
              <div class="reply-form active" id="reply-{replyPost.id}">
                <textarea
                  bind:value={replyContent}
                  on:input={handleInput}
                  on:keydown={(e) => handleKeydown(e, replyPost.id)}
                  placeholder="Reply..."
                  rows="1"
                ></textarea>
                <button
                  class="send-btn"
                  on:click={() => submitReply(replyPost.id)}>➤</button
                >
              </div>
            {/if}
          </div>
        {/each}
      </div>
    {/each}
  </div>
  <div class="post-form" class:minimized>
    {#if minimized}
      <div class="minimized-bar">
        <button class="toggle-btn" on:click={toggleMinimize}>↑</button>
      </div>
    {:else}
      <div class="input-container">
        <textarea
          bind:value={newPost}
          on:input={handleInput}
          on:keydown={(e) => handleKeydown(e, null)}
          placeholder="Say something..."
          rows="2"
        ></textarea>
        <button class="send-btn" on:click={submitPost}>➤</button>
        <button class="toggle-btn" on:click={toggleMinimize}>↓</button>
      </div>
      {#if showTagPicker && tagSuggestions.length > 0}
        <div class="tag-picker">
          {#each tagSuggestions as username}
            <div
              class="tag-suggestion"
              role="button"
              tabindex="0"
              on:click={() => addTag(username)}
              on:keydown={(e) => handleKeyPress(e, () => addTag(username))}
            >
              {username}
            </div>
          {/each}
        </div>
      {/if}
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
        <button
          type="button"
          on:click={() => (showGifPicker = !showGifPicker)}
          title="GIF"
        >
          <span>🎞️</span>
        </button>
        <button
          type="button"
          on:click={() => (showEmojiPicker = !showEmojiPicker)}
          title="Emoji"
        >
          <span>😊</span>
        </button>
      </div>
      {#if showGifPicker}
        <div class="gif-picker">
          <input
            type="text"
            bind:value={gifSearch}
            on:input={searchGifs}
            placeholder="Search GIFs"
          />
          <div class="gif-list">
            {#each gifs as gif}
              <button
                type="button"
                class="gif-button"
                on:click={() => addGif(gif.url)}
                on:keydown={(e) => handleKeyPress(e, () => addGif(gif.url))}
              >
                <img src={gif.url} alt="GIF" />
              </button>
            {/each}
          </div>
        </div>
      {/if}
      {#if showEmojiPicker}
        <div class="emoji-picker">
          {#each ["😊", "👍", "😂", "❤️", "🔥"] as emoji}
            <button
              type="button"
              class="emoji-button"
              on:click={() => addEmoji(emoji)}
              on:keydown={(e) => handleKeyPress(e, () => addEmoji(emoji))}
            >
              {emoji}
            </button>
          {/each}
        </div>
      {/if}
    {/if}
  </div>
</div>

<style>
  .feed-container {
    display: flex;
    flex-direction: column;
    max-width: 450px;
    width: 100%;
    margin: 0 auto;
    min-height: calc(100vh - 60px);
  }
  .feed {
    flex: 1;
    overflow-y: auto;
    padding: 0.25rem;
    font-size: 0.9rem;
    padding-bottom: 150px;
  }
  .post-form {
    padding: 0.25rem;
    display: flex;
    flex-direction: column;
    gap: 0.25rem;
    position: fixed;
    bottom: 60px;
    width: 100%;
    max-width: 450px;
    left: 50%;
    transform: translateX(-50%);
    background: var(--white);
    z-index: 1000;
    box-shadow: 0 -2px 5px rgba(0, 0, 0, 0.1);
    transition: height 0.3s ease;
  }
  .post-form.minimized {
    height: 40px;
  }
  @media (min-width: 769px) {
    .post-form {
      bottom: 0;
    }
  }
  .minimized-bar {
    display: flex;
    justify-content: flex-end;
    align-items: center;
    height: 40px;
    padding: 0 0.5rem;
  }
  .post.reply,
  .reply {
    margin-left: 1rem;
    border-left: 1px solid #ccc;
    padding-left: 0.5rem;
  }
  .input-container,
  .reply-form {
    position: relative;
    display: flex;
    align-items: center;
  }
  .post-form textarea,
  .reply-form textarea {
    width: 100%;
    resize: none;
    padding: 0.25rem 2rem 0.25rem 0.25rem;
    border: 1px solid var(--light-gray);
    border-radius: 4px;
    font-size: clamp(0.75rem, 2vw, 0.85rem);
    min-height: clamp(20px, 5vw, 28px);
    line-height: 1.2;
  }
  .send-btn {
    position: absolute;
    right: 2rem;
    bottom: 0.25rem;
    padding: 0.25rem 0.5rem; /* Reduced padding for smaller button */
    background-color: var(--tomato);
    color: var(--white);
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 0.7rem; /* Smaller font size */
    transition: background-color 0.3s;
    width: auto;
    height: auto;
  }
  .toggle-btn {
    position: absolute;
    right: 0.25rem;
    bottom: 0.25rem;
    padding: 0.25rem 0.5rem; /* Reduced padding for consistency */
    background-color: var(--charcoal);
    color: var(--white);
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 0.7rem; /* Smaller font size */
    transition: background-color 0.3s;
    width: auto;
    height: auto;
  }
  .minimized-bar .toggle-btn {
    position: static;
    margin: 0;
  }
  .send-btn:hover,
  .toggle-btn:hover {
    background-color: var(--tomato-light);
  }
  .toolbar,
  .nested-toolbar {
    display: flex;
    gap: 0.25rem;
    flex-wrap: wrap;
  }
  .toolbar button,
  .nested-toolbar button {
    padding: 0.25rem;
    background: none;
    border: none;
    font-size: clamp(0.8rem, 2vw, 0.9rem);
    cursor: pointer;
    color: var(--charcoal);
  }
  .toolbar button:hover,
  .nested-toolbar button:hover {
    color: var(--tomato);
  }
  .gif-picker,
  .emoji-picker,
  .tag-picker,
  .reaction-picker {
    position: absolute;
    background: var(--white);
    border: 1px solid var(--light-gray);
    border-radius: 4px;
    padding: 0.5rem;
    z-index: 2000;
    max-width: 100%;
  }
  .gif-picker {
    bottom: calc(100% + 5px);
    left: 0;
  }
  .gif-picker input {
    width: 100%;
    margin-bottom: 0.5rem;
    font-size: clamp(0.7rem, 2vw, 0.8rem);
  }
  .gif-list {
    display: flex;
    flex-wrap: wrap;
    gap: 0.25rem;
    max-height: 150px;
    overflow-y: auto;
  }
  .gif-button {
    padding: 0;
    background: none;
    border: none;
    cursor: pointer;
  }
  .gif-list img {
    width: clamp(60px, 20vw, 80px);
    height: clamp(60px, 20vw, 80px);
    border-radius: 4px;
  }
  .emoji-button {
    padding: 0.25rem;
    background: none;
    border: none;
    font-size: clamp(0.8rem, 2vw, 0.9rem);
    cursor: pointer;
    color: var(--charcoal);
  }
  .emoji-button:hover {
    color: var(--tomato);
  }
  .reaction-picker {
    bottom: 100%;
    left: 0;
    display: flex;
    gap: 0.25rem;
  }
  .reaction-picker button {
    padding: 0.25rem;
    font-size: clamp(0.8rem, 2vw, 0.9rem);
  }
  .tag-picker {
    max-height: 150px;
    overflow-y: auto;
  }
  .tag-suggestion {
    padding: 0.25rem;
    font-size: clamp(0.75rem, 2vw, 0.85rem);
  }
  .tag-suggestion:hover,
  .tag-suggestion:focus {
    background-color: var(--light-gray);
  }
  .post {
    border-bottom: 1px solid #eee;
    padding: 0.5rem 0;
  }
  .post-meta {
    font-size: clamp(0.65rem, 2vw, 0.75rem);
    color: var(--gray);
    margin: 0;
  }
  .challenge-name {
    color: var(--dark-moderate-pink);
  }
  .username {
    color: var(--lapis-lazuli);
    cursor: pointer;
  }
  .username:hover {
    text-decoration: underline;
  }
  .post-content {
    font-size: clamp(0.75rem, 2.5vw, 0.85rem);
    margin: 0.25rem 0;
    white-space: pre-wrap;
  }
  .media img,
  .media video {
    max-width: 100%;
    margin-top: 0.25rem;
    border-radius: 4px;
  }
  .reactions {
    display: flex;
    gap: 0.5rem;
    margin-top: 0.25rem;
    align-items: center;
    position: relative;
  }
  .reaction-btn {
    padding: 0.2rem 0.5rem;
    background: none;
    border: none;
    font-size: clamp(0.75rem, 2vw, 0.85rem);
    cursor: pointer;
    color: var(--charcoal);
  }
  .reaction-btn:hover {
    color: var(--tomato);
  }
  .reaction-count {
    font-size: clamp(0.65rem, 2vw, 0.75rem);
    color: var(--charcoal);
    cursor: pointer;
  }
  .reaction-count:hover {
    color: var(--tomato);
  }
  .comment-link {
    font-size: clamp(0.55rem, 1.5vw, 0.65rem);
    padding: 0.1rem 0.3rem;
    color: var(--tomato);
    text-decoration: underline;
    cursor: pointer;
    line-height: 1;
  }
  .comment-link:hover {
    color: var(--tomato-light);
  }
  .reply-form {
    margin-top: 0.25rem;
    display: none; /* Hidden by default */
  }
  .reply-form.active {
    display: flex;
    gap: 0.25rem;
    align-items: center;
  }
</style>
