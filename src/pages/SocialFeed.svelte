<script>
  import { onMount, onDestroy } from "svelte";
  import { supabase } from "../supabase.js";
  import { user } from "../stores.js";
  import Comment from "./Comment.svelte"; // Import the new component

  export let challengeId = null;
  export let challengeName = "bl0b-general";

  let posts = [];
  let originalPost = null;
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
  let replyingTo = null;
  let replyContent = "";
  let minimized = false;
  let expandedComments = {}; // Tracks expanded comment sections by post ID
  let expandedReplies = {}; // Tracks expanded reply sections by comment ID

  const GIPHY_API_KEY = "lGJJOnOXxAtmYy5GaKCId3RDdah90xaG";
  const COMMENTS_PER_PAGE = 5;

  onMount(async () => {
    console.log("SocialFeed mounted with challengeId:", challengeId);
    await fetchCurrentUserUsername();
    await fetchPosts(); // Ensure posts load even if user is null
    await fetchParticipants();
    const channelName = challengeId
      ? `public:posts:challenge_id=eq.${challengeId}`
      : "public:posts:general";
    const channel = supabase
      .channel(channelName)
      .on(
        "postgres_changes",
        {
          event: "INSERT",
          schema: "public",
          table: "posts",
          filter: challengeId ? `challenge_id=eq.${challengeId}` : null,
        },
        (payload) => {
          console.log("New post received via subscription:", payload.new);
          const newPostData = {
            ...payload.new,
            timestamp: new Date(payload.new.created_at).toLocaleString(
              "en-US",
              {
                hour: "numeric",
                minute: "numeric",
                hour12: true,
              }
            ),
            username: currentUserUsername || "Anonymous", // Fallback if no username
            reactions: [],
            challenge_title: payload.new.challenge_id
              ? challengeName
              : "bl0b-general",
            comments: [],
          };
          if (!challengeId || newPostData.challenge_id === challengeId) {
            if (newPostData.parent_id === null && !originalPost) {
              originalPost = newPostData;
            } else {
              posts = [newPostData, ...posts];
            }
            console.log("Updated posts array after subscription:", posts);
          }
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
    if (!$user) {
      console.warn("User not authenticated, using 'Anonymous' as username");
      currentUserUsername = "Anonymous";
      return; // Skip Supabase call if no user
    }
    const { data, error } = await supabase
      .from("profiles")
      .select("username")
      .eq("id", $user.id)
      .single();
    if (error) {
      console.error("Error fetching username:", error);
      currentUserUsername = "Anonymous"; // Fallback if error
    } else {
      currentUserUsername = data.username || "Anonymous";
      console.log("Fetched current user username:", currentUserUsername);
    }
  }

  async function fetchPosts() {
    try {
      let query = supabase
        .from("posts")
        .select(
          "id, user_id, content, color_code, created_at, challenge_id, media_url, parent_id, post_reactions(reaction_type, user_id, profiles(username)), challenges(title)"
        )
        .order("created_at", { ascending: false });

      if (challengeId) {
        // For challenge page, fetch all posts for the specific challenge
        query = query.eq("challenge_id", challengeId);
      } else {
        // For home page (bl0b-general), fetch all posts without challenge_id or public posts
        if (!$user) {
          console.log(
            "Fetching public and general posts for unauthenticated user"
          );
          query = query.or("challenge_id.is.null,user_id.is.null");
        } else {
          const { data: friendData, error: friendError } = await supabase
            .from("friendships")
            .select("friend_id")
            .eq("user_id", $user.id);
          if (friendError) throw friendError;

          const { data: participantData, error: participantError } =
            await supabase
              .from("challenge_participants")
              .select("challenge_id")
              .eq("user_id", $user.id);
          if (participantError) throw participantError;

          const friendIds = friendData.map((f) => f.friend_id);
          const challengeIds = participantData.map((p) => p.challenge_id);
          const relevantUserIds = [$user.id, ...friendIds].filter(Boolean);

          query = query
            .in(
              "user_id",
              relevantUserIds.length > 0 ? relevantUserIds : [$user.id]
            )
            .or(
              `challenge_id.in.(${challengeIds.join(",")}),challenge_id.is.null`
            );
        }
      }

      const { data: postsData, error: postsError } = await query;
      if (postsError) {
        console.error("Fetch posts error:", postsError);
        throw postsError;
      }
      console.log("Raw posts data from Supabase:", postsData);
      if (!postsData || postsData.length === 0) {
        console.log("No posts found for challengeId:", challengeId);
        posts = [];
        originalPost = null;
        return;
      }

      const userIds = [
        ...new Set(postsData.map((post) => post.user_id).filter(Boolean)),
      ];
      console.log("User IDs to fetch profiles for:", userIds);
      const { data: profilesData, error: profilesError } = await supabase
        .from("profiles")
        .select("id, username")
        .in("id", userIds);
      if (profilesError) {
        console.error("Profiles fetch error:", profilesError);
      }
      console.log("Fetched profiles:", profilesData || "None");
      const usernameMap = new Map(
        profilesData ? profilesData.map((p) => [p.id, p.username]) : []
      );

      const allPosts = postsData.map((post) => {
        let mediaUrl = post.media_url;
        try {
          if (typeof mediaUrl === "string") {
            mediaUrl = JSON.parse(mediaUrl);
          }
          mediaUrl =
            Array.isArray(mediaUrl) && mediaUrl.length > 0 ? mediaUrl[0] : null;
        } catch (e) {
          console.warn("Failed to parse media_url for post", post.id, ":", e);
          mediaUrl = null;
        }
        return {
          ...post,
          timestamp: new Date(post.created_at).toLocaleString("en-US", {
            hour: "numeric",
            minute: "numeric",
            hour12: true,
          }),
          username: post.user_id
            ? usernameMap.get(post.user_id) || "Unknown"
            : "Unknown",
          reactions: post.post_reactions || [],
          media_url: mediaUrl,
          challenge_title: post.challenge_id
            ? post.challenges?.title || "Unknown"
            : "bl0b-general",
          comments: [],
        };
      });

      // Build a complete comment hierarchy recursively with detailed logging
      function buildHierarchy(posts, parentId = null) {
        const children = posts
          .filter((post) => post.parent_id === parentId)
          .map((post) => ({
            ...post,
            comments: buildHierarchy(posts, post.id), // Recursively build all nested replies
          }))
          .sort((a, b) => new Date(b.created_at) - new Date(a.created_at));

        console.log(
          `Building hierarchy for parentId ${parentId || "null"}: Found ${children.length} children, deepest nesting: ${getDeepestNesting(children)}`
        );
        return children;
      }

      // Helper to calculate deepest nesting level for debugging
      function getDeepestNesting(posts, level = 0) {
        if (!posts || posts.length === 0) return level;
        return Math.max(
          ...posts.map((post) => getDeepestNesting(post.comments, level + 1))
        );
      }

      const topLevelPosts = buildHierarchy(allPosts, null);
      const originalIdx = topLevelPosts.findIndex((p) => p.parent_id === null);
      if (originalIdx !== -1) {
        originalPost = topLevelPosts.splice(originalIdx, 1)[0];
      } else {
        originalPost = null;
      }
      posts = topLevelPosts;
      console.log("Processed original post:", originalPost);
      console.log("Processed top-level posts:", posts);
      console.log(
        "Rendering posts with nested structure:",
        posts.map((p) => ({
          id: p.id,
          content: p.content,
          commentsCount: p.comments.length,
          nestedStructure: p.comments.map((c) => ({
            id: c.id,
            content: c.content,
            commentsCount: c.comments.length,
            nestedReplies: c.comments.map((r) => ({
              id: r.id,
              content: r.content,
              commentsCount: r.comments.length,
            })),
          })),
        }))
      );
    } catch (err) {
      console.error("Error fetching posts:", err);
      posts = [];
      originalPost = null;
    }
  }

  async function fetchParticipants() {
    try {
      let participantIds = [];
      if (challengeId) {
        const { data, error } = await supabase
          .from("challenge_participants")
          .select("user_id")
          .eq("challenge_id", challengeId);
        if (error) throw error;
        participantIds = data.map((p) => p.user_id);
      } else {
        const { data: friendData, error: friendError } = await supabase
          .from("friendships")
          .select("friend_id")
          .eq("user_id", $user?.id || null); // Use optional chaining
        if (friendError) throw friendError;

        const { data: participantData, error: participantError } =
          await supabase
            .from("challenge_participants")
            .select("user_id")
            .eq("user_id", $user?.id || null); // Use optional chaining
        if (participantError) throw participantError;

        participantIds = [
          ...new Set([
            ...(friendData?.map((f) => f.friend_id) || []),
            ...(participantData?.map((p) => p.user_id) || []),
            $user?.id || null,
          ]),
        ].filter(Boolean); // Filter out null/undefined
      }

      const { data: profilesData, error: profilesError } = await supabase
        .from("profiles")
        .select("username")
        .in("id", participantIds);
      if (profilesError) throw profilesError;

      participants = profilesData.map((p) => p.username).filter(Boolean);
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
    let mediaUrl = null;
    if (mediaFiles.length > 0) {
      mediaUrl = await uploadMedia(mediaFiles[0]);
    }
    const { data, error } = await supabase
      .from("posts")
      .insert([
        {
          challenge_id: challengeId,
          content: newPost,
          user_id: $user?.id || null, // Use optional chaining
          media_url: mediaUrl,
          parent_id: null,
          created_at: new Date().toISOString(),
          color_code: "#ffffff",
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
      await fetchPosts();
    }
  }

  async function submitReply(postId) {
    if (!replyContent.trim()) return;
    const parentPost = posts.find((p) => p.id === postId) || originalPost;
    const parentUsername = parentPost ? parentPost.username : null;
    const finalContent = parentUsername
      ? `@${parentUsername} ${replyContent}`
      : replyContent;
    const { data, error } = await supabase
      .from("posts")
      .insert([
        {
          challenge_id: challengeId || parentPost.challenge_id,
          content: finalContent,
          user_id: $user?.id || null, // Use optional chaining
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
      showEmojiPicker = false;
      showGifPicker = false;
      showTagPicker = false;
      await fetchPosts();
    }
  }

  async function toggleReaction(postId, reactionType) {
    const post = posts.find((p) => p.id === postId) || originalPost;
    const existingReaction = post.reactions.find(
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
    await fetchPosts();
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

  function toggleComments(postId) {
    expandedComments[postId] = !expandedComments[postId];
    expandedComments = { ...expandedComments }; // Ensure reactivity by creating a new object
    console.log(
      "Toggled comments for postId:",
      postId,
      "Expanded:",
      expandedComments[postId],
      "State:",
      expandedComments
    );
  }

  function getVisibleComments(post) {
    const isExpanded = expandedComments[post.id] === true; // Explicitly check for true
    console.log(
      "Getting visible comments for postId:",
      post.id,
      "Is Expanded:",
      isExpanded,
      "Comments:",
      post.comments
    );
    return isExpanded
      ? post.comments
      : post.comments.slice(0, COMMENTS_PER_PAGE);
  }

  function getVisibleReplies(comment) {
    const isExpanded = expandedReplies[comment.id] === true; // Use expandedReplies instead of expandedComments
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
</script>

<div class="feed-container">
  <div class="feed">
    {#if originalPost}
      <div class="post">
        <p class="post-meta">
          {originalPost.timestamp} |
          <span class="challenge-name" role="button" tabindex="0"
            >#{originalPost.challenge_title}</span
          >
          |
          <span
            class="username"
            role="button"
            tabindex="0"
            on:click={() => tagUser(originalPost.id, originalPost.username)}
            on:keydown={(e) =>
              handleKeyPress(e, () =>
                tagUser(originalPost.id, originalPost.username)
              )}
          >
            @{originalPost.username}
          </span>
        </p>
        <p class="post-content">{originalPost.content}</p>
        {#if originalPost.media_url}
          <div class="media">
            {#if originalPost.media_url.match(/\.(mp4|webm)$/i)}
              <video src={originalPost.media_url} controls width="100%">
                <track kind="captions" label="No captions available" />
              </video>
            {:else}
              <img src={originalPost.media_url} alt="Post media" />
            {/if}
          </div>
        {/if}
        <div class="reactions">
          <button
            class="reaction-btn"
            on:click={() =>
              (showReactionPicker =
                showReactionPicker === originalPost.id
                  ? null
                  : originalPost.id)}
          >
            🙂➕
          </button>
          {#if showReactionPicker === originalPost.id}
            <div class="reaction-picker">
              <button on:click={() => toggleReaction(originalPost.id, "like")}
                >👍</button
              >
              <button on:click={() => toggleReaction(originalPost.id, "heart")}
                >❤️</button
              >
              <button on:click={() => toggleReaction(originalPost.id, "laugh")}
                >😂</button
              >
              <button on:click={() => toggleReaction(originalPost.id, "cry")}
                >😢</button
              >
              <button
                on:click={() => toggleReaction(originalPost.id, "comfort")}
                >🤗</button
              >
            </div>
          {/if}
          {#each ["like", "heart", "laugh", "cry", "comfort"] as type}
            {#if originalPost.reactions.some((r) => r.reaction_type === type)}
              <span
                class="reaction-count"
                title={originalPost.reactions
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
                +{originalPost.reactions.filter((r) => r.reaction_type === type)
                  .length}
              </span>
            {/if}
          {/each}
          <a
            href="#comment"
            class="comment-link"
            on:click|preventDefault={() => toggleReply(originalPost.id)}
          >
            Comment
          </a>
        </div>
        {#if replyingTo === originalPost.id}
          <div class="reply-form active" id="reply-{originalPost.id}">
            <textarea
              bind:value={replyContent}
              on:input={handleInput}
              on:keydown={(e) => handleKeydown(e, originalPost.id)}
              placeholder="Reply..."
              rows="1"
            ></textarea>
            <button
              class="send-btn"
              on:click={() => submitReply(originalPost.id)}>➤</button
            >
          </div>
        {/if}
        {#if originalPost.comments.length > 0}
          <div class="comments">
            {#each getVisibleComments(originalPost) as comment}
              <Comment
                {comment}
                level={1}
                {challengeId}
                {currentUserUsername}
                on:replySubmitted={() => fetchPosts()}
              />
            {/each}
            {#if originalPost.comments.length > COMMENTS_PER_PAGE}
              <a
                href="#view-all"
                class="view-more-link"
                on:click|preventDefault={() => toggleComments(originalPost.id)}
              >
                {expandedComments[originalPost.id]
                  ? "Hide Comments..."
                  : "View All Comments..."}
              </a>
            {/if}
          </div>
        {/if}
      </div>
    {/if}

    {#each posts as post}
      <div class="post">
        <p class="post-meta">
          {post.timestamp} |
          <span class="challenge-name" role="button" tabindex="0"
            >#{post.challenge_title}</span
          >
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
        {#if post.media_url}
          <div class="media">
            {#if post.media_url.match(/\.(mp4|webm)$/i)}
              <video src={post.media_url} controls width="100%">
                <track kind="captions" label="No captions available" />
              </video>
            {:else}
              <img src={post.media_url} alt="Post media" />
            {/if}
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
            on:click|preventDefault={() => toggleReply(post.id)}
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
        {#if post.comments.length > 0}
          <div class="comments">
            {#each getVisibleComments(post) as comment}
              <Comment
                {comment}
                level={1}
                {challengeId}
                {currentUserUsername}
                on:replySubmitted={() => fetchPosts()}
              />
            {/each}
            {#if post.comments.length > COMMENTS_PER_PAGE}
              <a
                href="#view-all"
                class="view-more-link"
                on:click|preventDefault={() => toggleComments(post.id)}
              >
                {expandedComments[post.id]
                  ? "Hide Comments..."
                  : "View All Comments..."}
              </a>
            {/if}
          </div>
        {/if}
      </div>
    {/each}
    {#if !originalPost && posts.length === 0}
      <p>No posts yet.</p>
    {/if}
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
  .post {
    border-bottom: 1px solid #eee;
    padding: 0.5rem 0;
    font-size: clamp(0.75rem, 2.5vw, 0.85rem); /* Consistent font size */
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
    padding: 0.25rem 0.5rem;
    background-color: var(--tomato);
    color: var(--white);
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 0.7rem;
    transition: background-color 0.3s;
    width: auto;
    height: auto;
  }
  .toggle-btn {
    position: absolute;
    right: 0.25rem;
    bottom: 0.25rem;
    padding: 0.25rem 0.5rem;
    background-color: var(--charcoal);
    color: var(--white);
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 0.7rem;
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
  .toolbar {
    display: flex;
    gap: 0.25rem;
    flex-wrap: wrap;
  }
  .toolbar button {
    padding: 0.25rem;
    background: none;
    border: none;
    font-size: clamp(0.8rem, 2vw, 0.9rem);
    cursor: pointer;
    color: var(--charcoal);
  }
  .toolbar button:hover {
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
  .post-meta {
    font-size: clamp(0.65rem, 2vw, 0.75rem);
    color: var(--gray);
    margin: 0;
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
  .comments {
    margin-top: 0.5rem;
  }
  .view-more-link {
    font-size: clamp(0.65rem, 2vw, 0.75rem);
    color: var(--tomato);
    text-decoration: underline;
    cursor: pointer;
    display: block;
    margin-top: 0.25rem;
    margin-left: 1rem;
  }
  .view-more-link:hover {
    color: var(--tomato-light);
  }
</style>
