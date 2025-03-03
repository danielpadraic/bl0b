<script>
  import Comment from "./Comment.svelte"; // Import the Comment component
  import { supabase } from "../supabase.js";
  import { user } from "../stores.js";

  export let comment;
  export let level = 0; // Tracks nesting level for indentation
  export let challengeId;
  export let currentUserUsername;
  let showReactionPicker = false;
  let replyingTo = null;
  let replyContent = "";
  let expandedReplies = {}; // Tracks expanded replies for this comment

  console.log(
    "Rendering comment:",
    comment,
    "Level:",
    level,
    "Comments:",
    comment.comments
  );

  async function toggleReaction(postId, reactionType) {
    const existingReaction = comment.reactions.find(
      (r) => r.user_id === $user?.id && r.reaction_type === reactionType
    );
    if (existingReaction) {
      const { error } = await supabase
        .from("post_reactions")
        .delete()
        .eq("post_id", postId)
        .eq("user_id", $user?.id)
        .eq("reaction_type", reactionType);
      if (error) console.error("Error removing reaction:", error);
    } else {
      const { error } = await supabase
        .from("post_reactions")
        .insert([
          { post_id: postId, user_id: $user?.id, reaction_type: reactionType },
        ]);
      if (error) console.error("Error adding reaction:", error);
    }
    // Parent will handle refetching
  }

  async function submitReply(postId) {
    if (!replyContent.trim()) return;
    const finalContent = `@${comment.username} ${replyContent}`;
    const { data, error } = await supabase
      .from("posts")
      .insert([
        {
          challenge_id: challengeId || comment.challenge_id,
          content: finalContent,
          user_id: $user?.id,
          media_url: null,
          parent_id: postId,
          created_at: new Date().toISOString(),
          color_code: "#ffffff",
        },
      ])
      .select();
    if (error) {
      console.error("Error submitting reply:", error);
    } else {
      console.log("Reply inserted:", data);
      replyContent = "";
      replyingTo = null;
      // Dispatch a custom event to notify the parent
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

  function toggleReplies(commentId) {
    expandedReplies[commentId] = !expandedReplies[commentId];
    expandedReplies = { ...expandedReplies }; // Ensure reactivity by creating a new object
    console.log(
      "Toggled replies for commentId:",
      commentId,
      "Expanded:",
      expandedReplies[commentId],
      "State:",
      expandedReplies
    );
  }

  function getVisibleReplies() {
    const isExpanded = expandedReplies[comment.id] === true; // Explicitly check for true
    console.log(
      "Getting visible replies for commentId:",
      comment.id,
      "Is Expanded:",
      isExpanded,
      "Comments:",
      comment.comments
    );
    return isExpanded ? comment.comments : comment.comments.slice(0, 1);
  }

  // Dispatch custom event for reply submission
  function dispatch(eventName, detail = {}) {
    window.dispatchEvent(new CustomEvent(eventName, { detail }));
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
      {#each getVisibleReplies() as reply (reply.id)}
        <!-- Use key for reactivity -->
        <Comment
          comment={reply}
          level={level + 1}
          {challengeId}
          {currentUserUsername}
          on:replySubmitted={() => dispatch("replySubmitted")}
        />
      {/each}
      {#if comment.comments.length > 1}
        <a
          href="#view-all"
          class="view-more-link"
          on:click|preventDefault={() => toggleReplies(comment.id)}
        >
          {expandedReplies[comment.id] ? "Hide Replies..." : "All Replies..."}
        </a>
      {/if}
    </div>
  {/if}
</div>

<style>
  .comment {
    border-bottom: 1px solid #eee;
    padding: 0.5rem 0;
    font-size: clamp(0.75rem, 2.5vw, 0.85rem); /* Consistent font size */
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
    font-size: clamp(
      0.75rem,
      2vw,
      0.85rem
    ); /* Consistent with main reactions */
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

  .post-content {
    font-size: clamp(0.75rem, 2.5vw, 0.85rem);
    margin: 0.25rem 0;
    white-space: pre-wrap;
  }
</style>
