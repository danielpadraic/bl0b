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
  let showGifPicker = false;
  let gifs = [];
  let gifSearch = "";
  let participants = [];
  let showTagPicker = false;
  let tagSuggestions = [];
  let tagStartIndex = -1;
  let currentUserUsername = "";
  let showReactionPicker = null;
  let nestedReplyTo = null;
  let nestedReplyContent = "";

  const GIPHY_API_KEY = "lGJJOnOXxAtmYy5GaKCId3RDdah90xaG";

  onMount(async () => {
    await fetchCurrentUserUsername();
    await fetchPosts();
    await fetchParticipants();
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
    }
  }

  async function fetchPosts() {
    const { data, error } = await supabase
      .from("posts")
      .select("*, post_reactions(reaction_type, user_id, profiles(username))")
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
        reactions: post.post_reactions || [],
      }));
    }
  }

  async function fetchParticipants() {
    const { data, error } = await supabase
      .from("challenge_participants")
      .select("user_id, profiles(username)")
      .eq("challenge_id", challengeId);
    if (error) {
      console.error("Error fetching participants:", error);
    } else {
      participants = data.map((p) => p.profiles.username).filter(Boolean);
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
      posts = [
        {
          ...data[0],
          timestamp: new Date().toLocaleString("en-US", {
            hour: "numeric",
            minute: "numeric",
            hour12: true,
          }),
          username: currentUserUsername,
          reactions: [],
        },
        ...posts,
      ];
      newPost = "";
      mediaFiles = [];
      showEmojiPicker = false;
      showGifPicker = false;
      showTagPicker = false;
    }
  }

  async function submitReply(
    parentId,
    isNested = false,
    targetUsername = null
  ) {
    const content = isNested ? `${nestedReplyContent}` : replyContent;
    if (!content.trim()) return;
    const finalContent = targetUsername
      ? `@${targetUsername} ${content}`
      : content;
    const { data, error } = await supabase
      .from("posts")
      .insert([
        {
          challenge_id: challengeId,
          content: finalContent,
          user_id: $user.id,
          username: currentUserUsername,
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
          username: currentUserUsername,
          reactions: [],
        },
        ...posts,
      ];
      if (isNested) {
        nestedReplyContent = "";
        nestedReplyTo = null;
      } else {
        replyContent = "";
        replyingTo = null;
      }
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
    await fetchPosts();
    showReactionPicker = null;
  }

  function handleMediaChange(event, isNested = false) {
    mediaFiles = Array.from(event.target.files);
    if (isNested) {
      submitReply(nestedReplyTo, true);
    } else {
      submitPost();
    }
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

  function addGif(gifUrl, isNested = false) {
    mediaFiles = [{ name: "gif", url: gifUrl }];
    if (isNested) {
      submitReply(nestedReplyTo, true);
    } else {
      submitPost();
    }
  }

  function addEmoji(emoji, isNested = false) {
    if (isNested) {
      nestedReplyContent += emoji;
    } else {
      newPost += emoji;
    }
    showEmojiPicker = false;
  }

  function toggleBold(isNested = false) {
    if (isNested) {
      nestedReplyContent = nestedReplyContent.trim()
        ? `**${nestedReplyContent}**`
        : nestedReplyContent;
    } else {
      newPost = newPost.trim() ? `**${newPost}**` : newPost;
    }
  }

  function toggleItalic(isNested = false) {
    if (isNested) {
      nestedReplyContent = nestedReplyContent.trim()
        ? `_${nestedReplyContent}_`
        : nestedReplyContent;
    } else {
      newPost = newPost.trim() ? `_${newPost}_` : newPost;
    }
  }

  function addList(isNested = false) {
    if (isNested) {
      nestedReplyContent += "\n- ";
    } else {
      newPost += "\n- ";
    }
  }

  function addLocation(isNested = false) {
    if (isNested) {
      nestedReplyContent += "📍 Location";
    } else {
      newPost += "📍 Location";
    }
  }

  async function completeTask() {
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

  function handleInput(event, isNested = false) {
    const value = isNested ? nestedReplyContent : event.target.value;
    const cursorPos = isNested
      ? event.target.selectionStart
      : event.target.selectionStart;
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

  function handleKeydown(event, isNested = false) {
    if ((event.ctrlKey || event.metaKey) && event.key === "Enter") {
      event.preventDefault();
      if (isNested) {
        submitReply(nestedReplyTo, true);
      } else {
        submitPost();
      }
    }
  }

  function addTag(username, isNested = false) {
    if (isNested) {
      const before = nestedReplyContent.slice(0, tagStartIndex);
      const after = nestedReplyContent.slice(
        nestedReplyContent.indexOf(" ", tagStartIndex) !== -1
          ? nestedReplyContent.indexOf(" ", tagStartIndex)
          : nestedReplyContent.length
      );
      nestedReplyContent = `${before}@${username} ${after}`.trim();
    } else {
      const before = newPost.slice(0, tagStartIndex);
      const after = newPost.slice(
        newPost.indexOf(" ", tagStartIndex) !== -1
          ? newPost.indexOf(" ", tagStartIndex)
          : newPost.length
      );
      newPost = `${before}@${username} ${after}`.trim();
    }
    showTagPicker = false;
    tagStartIndex = -1;
    tagSuggestions = [];
  }

  function tagUser(username, parentId) {
    replyingTo = parentId;
    replyContent = `@${username} `;
    document.querySelector(".reply-form textarea")?.focus();
  }

  function tagNestedUser(username, parentId) {
    nestedReplyTo = parentId;
    nestedReplyContent = `@${username} `;
    document.querySelector(`#nested-reply-${parentId} textarea`)?.focus();
  }

  function handleKeyPress(event, action) {
    if (event.key === "Enter" || event.key === " ") {
      event.preventDefault();
      action();
    }
  }
</script>

<div class="feed-container">
  <div class="feed">
    {#each posts.filter((p) => !p.parent_id) as post}
      <div class="post">
        <p class="post-meta">
          {post.timestamp} |
          <span class="challenge-name">#{challengeName}</span>
          |
          <span
            class="username"
            role="button"
            tabindex="0"
            on:click={() => tagUser(post.username, post.id)}
            on:keydown={(e) =>
              handleKeyPress(e, () => tagUser(post.username, post.id))}
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
            on:click|preventDefault={() =>
              (replyingTo = replyingTo === post.id ? null : post.id)}
          >
            Comment
          </a>
        </div>
        {#if replyingTo === post.id}
          <div class="reply-form">
            <textarea bind:value={replyContent} placeholder="Reply..." rows="1"
            ></textarea>
            <button on:click={() => submitReply(post.id)}>➤</button>
          </div>
        {/if}
        {#each posts.filter((r) => r.parent_id === post.id) as reply}
          <div class="reply">
            <p class="post-meta">
              {reply.timestamp} |
              <span class="challenge-name">#{challengeName}</span>
              |
              <span
                class="username"
                role="button"
                tabindex="0"
                on:click={() => tagNestedUser(reply.username, post.id)}
                on:keydown={(e) =>
                  handleKeyPress(e, () =>
                    tagNestedUser(reply.username, post.id)
                  )}
              >
                @{reply.username}
              </span>
            </p>
            <p class="post-content">{reply.content}</p>
            <div class="reactions">
              <button
                class="reaction-btn"
                on:click={() =>
                  (showReactionPicker =
                    showReactionPicker === reply.id ? null : reply.id)}
              >
                🙂➕
              </button>
              {#if showReactionPicker === reply.id}
                <div class="reaction-picker">
                  <button on:click={() => toggleReaction(reply.id, "like")}
                    >👍</button
                  >
                  <button on:click={() => toggleReaction(reply.id, "heart")}
                    >❤️</button
                  >
                  <button on:click={() => toggleReaction(reply.id, "laugh")}
                    >😂</button
                  >
                  <button on:click={() => toggleReaction(reply.id, "cry")}
                    >😢</button
                  >
                  <button on:click={() => toggleReaction(reply.id, "comfort")}
                    >🤗</button
                  >
                </div>
              {/if}
              {#each ["like", "heart", "laugh", "cry", "comfort"] as type}
                {#if reply.reactions.some((r) => r.reaction_type === type)}
                  <span
                    class="reaction-count"
                    title={reply.reactions
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
                    +{reply.reactions.filter((r) => r.reaction_type === type)
                      .length}
                  </span>
                {/if}
              {/each}
              <a
                href="#comment"
                class="comment-link"
                on:click|preventDefault={() =>
                  (nestedReplyTo =
                    nestedReplyTo === reply.id ? null : reply.id)}
              >
                Comment
              </a>
            </div>
            {#if nestedReplyTo === reply.id}
              <div class="nested-reply-form" id="nested-reply-{reply.id}">
                <textarea
                  class="nested-reply-textarea"
                  bind:value={nestedReplyContent}
                  on:input={(e) => handleInput(e, true)}
                  on:keydown={(e) => handleKeydown(e, true)}
                  placeholder="Reply..."
                  rows="1"
                ></textarea>
                <button
                  class="nested-send-btn"
                  on:click={() => submitReply(post.id, true, reply.username)}
                  >➤</button
                >
                <div class="nested-toolbar">
                  <button
                    type="button"
                    on:click={() =>
                      document
                        .getElementById(`nested-media-${reply.id}`)
                        .click()}
                    title="Image"
                  >
                    <span>🖼️</span>
                  </button>
                  <input
                    id="nested-media-{reply.id}"
                    type="file"
                    multiple
                    accept="image/*,video/*"
                    on:change={(e) => handleMediaChange(e, true)}
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
                    on:click={() => addList(true)}
                    title="List"
                  >
                    <span>📋</span>
                  </button>
                  <button
                    type="button"
                    on:click={() => (showEmojiPicker = !showEmojiPicker)}
                    title="Emoji"
                  >
                    <span>😊</span>
                  </button>
                  <button
                    type="button"
                    on:click={() => addLocation(true)}
                    title="Location"
                  >
                    <span>📍</span>
                  </button>
                  <button
                    type="button"
                    on:click={() => toggleBold(true)}
                    title="Bold"
                  >
                    <span>𝐁</span>
                  </button>
                  <button
                    type="button"
                    on:click={() => toggleItalic(true)}
                    title="Italic"
                  >
                    <span>𝐈</span>
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
                          on:click={() => addGif(gif.url, true)}
                          on:keydown={(e) =>
                            handleKeyPress(e, () => addGif(gif.url, true))}
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
                        on:click={() => addEmoji(emoji, true)}
                        on:keydown={(e) =>
                          handleKeyPress(e, () => addEmoji(emoji, true))}
                      >
                        {emoji}
                      </button>
                    {/each}
                  </div>
                {/if}
              </div>
            {/if}
          </div>
        {/each}
      </div>
    {/each}
  </div>
  <div class="post-form">
    <div class="input-container">
      <textarea
        bind:value={newPost}
        on:input={handleInput}
        on:keydown={handleKeydown}
        placeholder="Say something..."
        rows="2"
      ></textarea>
      <button class="send-btn" on:click={submitPost}>➤</button>
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
        <span>𝐈</span>
      </button>
      <button
        type="button"
        on:click={() => (showTaskPicker = !showTaskPicker)}
        title="Complete Task"
      >
        <span>+""</span>
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
    {#if showTaskPicker}
      <div class="task-picker">
        <button on:click={completeTask}>Complete a Task</button>
      </div>
    {/if}
  </div>
</div>

<style>
  .feed-container {
    display: flex;
    flex-direction: column;
    height: calc(100vh - 60px);
  }
  .feed {
    flex: 1;
    overflow-y: auto;
    padding: 0.25rem;
    font-size: 0.9rem;
    padding-bottom: 100px;
  }
  .post-form {
    padding: 0.25rem;
    display: flex;
    flex-direction: column;
    gap: 0.25rem;
    position: fixed;
    bottom: 60px;
    left: 0;
    right: 0;
    background: var(--white);
    z-index: 1000;
    box-shadow: 0 -2px 5px rgba(0, 0, 0, 0.1);
  }
  .nested-reply-form {
    padding: 0.25rem;
    display: flex;
    flex-direction: column;
    gap: 0.25rem;
  }
  .input-container,
  .nested-reply-form {
    position: relative;
    display: flex;
    align-items: center;
  }
  .post-form textarea {
    width: 100%;
    resize: none;
    padding: 0.25rem 2rem 0.25rem 0.25rem;
    border: 1px solid var(--light-gray);
    border-radius: 4px;
    font-size: clamp(0.75rem, 2vw, 0.85rem);
    min-height: clamp(20px, 5vw, 28px);
    line-height: 1.2;
  }
  .nested-reply-textarea {
    width: 100%;
    resize: none;
    padding: 0.15rem 1.5rem 0.15rem 0.15rem;
    border: 1px solid var(--light-gray);
    border-radius: 4px;
    font-size: clamp(0.65rem, 1.5vw, 0.75rem);
    min-height: clamp(18px, 4vw, 22px);
    line-height: 1.1;
  }
  .send-btn {
    position: absolute;
    right: 0.25rem;
    bottom: 0.25rem;
    padding: clamp(0.05rem, 1vw, 0.1rem) clamp(0.15rem, 2vw, 0.3rem);
    background-color: var(--tomato);
    color: var(--white);
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: clamp(0.6rem, 1.5vw, 0.7rem);
    transition: background-color 0.3s;
    width: auto;
    height: auto;
  }
  .nested-send-btn {
    position: absolute;
    right: 0.15rem;
    bottom: 0.15rem;
    padding: clamp(0.03rem, 0.8vw, 0.05rem) clamp(0.1rem, 1.5vw, 0.2rem);
    background-color: var(--tomato);
    color: var(--white);
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: clamp(0.55rem, 1.2vw, 0.65rem);
    transition: background-color 0.3s;
    width: auto;
    height: auto;
  }
  .send-btn:hover,
  .nested-send-btn:hover {
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
  .task-picker,
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
    bottom: 100%;
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
  .reply-form,
  .nested-reply-form {
    margin-top: 0.25rem;
    display: flex;
    gap: 0.25rem;
    align-items: center;
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
  }
</style>
