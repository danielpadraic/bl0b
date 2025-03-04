<script>
  import { supabase } from "../supabase.js";
  import { user } from "../stores.js";
  // Import Comment for recursive use
  import Comment from "./Comment.svelte";

  export let comment;
  export let level = 0;
  export let challengeId;
  export let currentUserUsername;
  export let expandedComments;
  export let expandedReplies;

  let showReactionPicker = false;
  let replyingTo = null;
  let replyContent = "";
  const REPLIES_PER_PAGE = 1; // Initial number of replies to show
  const REPLIES_EXPAND_COUNT = 20; // Number of replies to show when expanded

  async function toggleReaction(postId, reactionType) {
    const existingReaction = comment.reactions.find(
      (r) => r.user_id === $user?.id && r.reaction_type === reactionType
    );
    if (existingReaction) {
      await supabase
        .from("post_reactions")
        .delete()
        .eq("post_id", postId)
        .eq("user_id", $user?.id)
        .eq("reaction_type", reactionType);
    } else {
      await supabase
        .from("post_reactions")
        .insert([
          { post_id: postId, user_id: $user?.id, reaction_type: reactionType },
        ]);
    }
    dispatch("replySubmitted");
  }

  async function submitReply(postId) {
    if (!replyContent.trim()) return;
    const finalContent = `@${comment.username} ${replyContent}`;
    const { error } = await supabase.from("posts").insert([
      {
        challenge_id: challengeId || comment.challenge_id,
        content: finalContent,
        user_id: $user?.id,
        media_url: null,
        parent_id: postId,
        created_at: new Date().toISOString(),
        color_code: "#ffffff",
      },
    ]);
    if (!error) {
      replyContent = "";
      replyingTo = null;
      dispatch("replySubmitted");
    }
  }

  function toggleReply(postId) {
    replyingTo = replyingTo === postId ? null : postId;
    if (replyingTo) {
      replyContent = "";
      setTimeout(() => {
        const textarea = document.querySelector(`#reply-${postId} textarea`);
        if (textarea) textarea.focus();
      }, 0);
    }
  }

  function toggleReplies(commentId) {
    if (!expandedReplies[commentId]) {
      expandedReplies[commentId] = REPLIES_EXPAND_COUNT;
    } else {
      expandedReplies[commentId] =
        expandedReplies[commentId] === REPLIES_PER_PAGE
          ? REPLIES_EXPAND_COUNT
          : REPLIES_PER_PAGE;
    }
    expandedReplies = { ...expandedReplies }; // Trigger reactivity
  }

  function getVisibleReplies(comment) {
    const limit = expandedReplies[comment.id] || REPLIES_PER_PAGE;
    return comment.comments.slice(0, limit);
  }

  function handleKeydown(event, postId) {
    if ((event.ctrlKey || event.metaKey) && event.key === "Enter") {
      event.preventDefault();
      submitReply(postId);
    }
  }

  function handleKeyPress(event, action) {
    if (event.key === "Enter" || event.key === " ") {
      event.preventDefault();
      action();
    }
  }

  function dispatch(eventName, detail = {}) {
    const event = new CustomEvent(eventName, { detail });
    window.dispatchEvent(event);
  }
</script>

<div class="comment" style="margin-left: {level * 1}rem;">
  <p class="post-meta">
    {comment.timestamp} |
    <span class="challenge-name" role="button" tabindex="0"
      >#{comment.challenge_title}</span
    >
    |
    <span
      class="username"
      role="button"
      tabindex="0"
      on:click={() => toggleReply(comment.id)}
      on:keydown={(e) => handleKeyPress(e, () => toggleReply(comment.id))}
    >
      @{comment.username}
    </span>
    {#if comment.isWhisper}
      <span class="whisper-label">[Whisper]</span>
    {/if}
  </p>
  <p class="post-content">{comment.content}</p>
  {#if comment.media_url}
    <div class="media">
      {#if comment.media_url.match(/\.(mp4|webm)$/i)}
        <video src={comment.media_url} controls width="100%">
          <track kind="captions" label="No captions available" />
        </video>
      {:else}
        <img src={comment.media_url} alt="Comment media" />
      {/if}
    </div>
  {/if}
  <div class="reactions">
    <button
      class="reaction-btn nested-reaction-btn"
      on:click={() => (showReactionPicker = !showReactionPicker)}
    >
      🙂➕
    </button>
    {#if showReactionPicker}
      <div class="reaction-picker">
        <button on:click={() => toggleReaction(comment.id, "like")}>👍</button>
        <button on:click={() => toggleReaction(comment.id, "heart")}>❤️</button>
        <button on:click={() => toggleReaction(comment.id, "laugh")}>😂</button>
        <button on:click={() => toggleReaction(comment.id, "cry")}>😢</button>
        <button on:click={() => toggleReaction(comment.id, "comfort")}
          >🤗</button
        >
      </div>
    {/if}
    {#each ["like", "heart", "laugh", "cry", "comfort"] as type}
      {#if comment.reactions.some((r) => r.reaction_type === type)}
        <span
          class="reaction-count"
          title={comment.reactions
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
          +{comment.reactions.filter((r) => r.reaction_type === type).length}
        </span>
      {/if}
    {/each}
    <a
      href="#comment"
      class="comment-link"
      on:click|preventDefault={() => toggleReply(comment.id)}
    >
      Reply
    </a>
  </div>
  {#if replyingTo === comment.id}
    <div class="reply-form active" id="reply-{comment.id}">
      <textarea
        bind:value={replyContent}
        on:keydown={(e) => handleKeydown(e, comment.id)}
        placeholder="Reply..."
        rows="1"
      ></textarea>
      <button class="send-btn" on:click={() => submitReply(comment.id)}
        >➤</button
      >
    </div>
  {/if}
  {#if comment.comments && comment.comments.length > 0}
    <div class="nested-comments">
      {#each getVisibleReplies(comment) as reply (reply.id)}
        <svelte:component
          this={Comment}
          comment={reply}
          level={level + 1}
          {challengeId}
          {currentUserUsername}
          {expandedComments}
          {expandedReplies}
          on:toggleComments={(e) => dispatch("toggleComments", e.detail)}
          on:toggleReplies={(e) => dispatch("toggleReplies", e.detail)}
          on:replySubmitted
        />
      {/each}
      {#if comment.comments.length > REPLIES_PER_PAGE}
        <a
          href="#view-replies"
          class="view-more-link"
          on:click|preventDefault={() => toggleReplies(comment.id)}
        >
          {expandedReplies[comment.id] &&
          expandedReplies[comment.id] > REPLIES_PER_PAGE
            ? "Hide Replies..."
            : "View More Replies..."}
        </a>
      {/if}
    </div>
  {/if}
</div>

<style>
  .comment {
    border-bottom: 1px solid #eee;
    padding: 0.5rem 0;
    font-size: clamp(0.75rem, 2.5vw, 0.85rem);
  }
  .nested-comments {
    margin-left: 1rem;
    border-left: 1px solid #eee;
    padding-left: 0.5rem;
  }
  .reaction-btn {
    padding: 0.2rem 0.5rem;
    background: none;
    border: none;
    font-size: clamp(0.75rem, 2vw, 0.85rem);
    cursor: pointer;
    color: var(--charcoal);
  }
  .nested-reaction-btn {
    font-size: clamp(0.75rem, 2vw, 0.85rem);
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
    display: none;
  }
  .reply-form.active {
    display: flex;
    gap: 0.25rem;
    align-items: center;
  }
  .reaction-picker {
    position: absolute;
    bottom: 100%;
    left: 0;
    background: var(--white);
    border: 1px solid var(--light-gray);
    border-radius: 4px;
    padding: 0.5rem;
    z-index: 2000;
    display: flex;
    gap: 0.25rem;
  }
  .reaction-picker button {
    padding: 0.25rem;
    font-size: clamp(0.8rem, 2vw, 0.9rem);
  }
  .media img,
  .media video {
    max-width: 100%;
    margin-top: 0.25rem;
    border-radius: 4px;
  }
  .challenge-name {
    color: var(--dark-moderate-pink);
    cursor: pointer;
  }
  .challenge-name:hover {
    text-decoration: underline;
  }
  .username {
    color: var(--lapis-lazuli);
    cursor: pointer;
  }
  .username:hover {
    text-decoration: underline;
  }
  .whisper-label {
    color: var(--tomato);
    font-style: italic;
    margin-left: 0.5rem;
  }
  .post-content {
    font-size: clamp(0.75rem, 2.5vw, 0.85rem);
    margin: 0.25rem 0;
    white-space: pre-wrap;
  }
</style>
