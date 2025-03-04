<script>
  import { onMount, onDestroy } from "svelte";
  import { supabase } from "../supabase.js";
  import { user } from "../stores.js";
  import { navigate } from "svelte-routing"; // Add this import
  import Comment from "./Comment.svelte";

  export let challengeId = null;
  export let challengeName = "bl0b-general";

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
  let replyingTo = null;
  let replyContent = "";
  let minimized = false;
  let expandedComments = {};
  let expandedReplies = {};
  let profilesMap = new Map();

  const GIPHY_API_KEY = "lGJJOnOXxAtmYy5GaKCId3RDdah90xaG";
  const COMMENTS_PER_PAGE = 3;

  onMount(async () => {
    console.log(
      "SocialFeed mounted with challengeId:",
      challengeId,
      "challengeName:",
      challengeName
    );
    console.log("Current user ID:", $user?.id);
    await fetchCurrentUserUsername();
    await fetchPosts();
    await fetchParticipants();

    const postChannel = supabase
      .channel(challengeId ? `posts:challenge:${challengeId}` : "posts:general")
      .on(
        "postgres_changes",
        {
          event: "INSERT",
          schema: "public",
          table: "posts",
          filter: challengeId ? `challenge_id=eq.${challengeId}` : null,
        },
        async (payload) => {
          console.log("New post received via subscription:", payload.new);
          if (!challengeId && payload.new.challenge_id) {
            const { data } = await supabase
              .from("challenge_participants")
              .select("user_id")
              .eq("challenge_id", payload.new.challenge_id)
              .eq("user_id", $user?.id);
            if (!data?.length) {
              console.log(
                "Skipping post: User not participant in challenge",
                payload.new.challenge_id
              );
              return;
            }
          }
          // Add new post directly to local state
          const newPostData = await processPost(payload.new);
          posts = [
            newPostData,
            ...posts.filter((p) => p.id !== newPostData.id),
          ];
          console.log("Updated posts with subscription:", posts);
        }
      )
      .subscribe();

    let whisperChannel;
    if (!challengeId && $user) {
      whisperChannel = supabase
        .channel("whispers:user:" + $user.id)
        .on(
          "postgres_changes",
          {
            event: "INSERT",
            schema: "public",
            table: "whispers",
            filter: `recipient_id=eq.${$user.id}`,
          },
          async (payload) => {
            console.log("New whisper received:", payload.new);
            const newWhisper = await processWhisper(payload.new);
            posts = [
              newWhisper,
              ...posts.filter((p) => p.id !== newWhisper.id),
            ];
            console.log("Updated posts with whisper:", posts);
          }
        )
        .subscribe();
    }

    return () => {
      supabase.removeChannel(postChannel);
      if (whisperChannel) supabase.removeChannel(whisperChannel);
    };
  });

  onDestroy(() => {
    console.log("SocialFeed destroyed, cleaning up subscriptions");
  });

  async function fetchCurrentUserUsername() {
    if (!$user) {
      currentUserUsername = "Anonymous";
      console.log("No user logged in, username set to Anonymous");
      return;
    }
    const { data, error } = await supabase
      .from("profiles")
      .select("username")
      .eq("id", $user.id)
      .single();
    currentUserUsername = error ? "Anonymous" : data?.username || "Anonymous";
    console.log("Fetched username:", currentUserUsername);
  }

  function buildPostTree(posts) {
    const postMap = new Map();
    posts.forEach((post) => {
      post.comments = [];
      postMap.set(post.id, post);
    });
    posts.forEach((post) => {
      if (post.parent_id) {
        const parent = postMap.get(post.parent_id);
        if (parent) {
          parent.comments.push(post);
        }
      }
    });
    const sortComments = (comments) => {
      comments.sort((a, b) => new Date(b.created_at) - new Date(a.created_at));
      comments.forEach((comment) => sortComments(comment.comments));
    };
    const tree = posts.filter((post) => !post.parent_id);
    tree.forEach((post) => sortComments(post.comments));
    return tree.sort((a, b) => new Date(b.created_at) - new Date(a.created_at));
  }

  async function fetchPosts() {
    try {
      console.log("Fetching posts for challengeId:", challengeId);
      let postsData = [];
      let whispersData = [];

      let query = supabase
        .from("posts")
        .select(
          "id, user_id, content, color_code, created_at, challenge_id, media_url, parent_id, post_reactions(reaction_type, user_id), challenges(title)"
        )
        .order("created_at", { ascending: false });

      if (challengeId) {
        query = query.eq("challenge_id", challengeId);
        console.log("Fetching posts for challenge_id:", challengeId);
      } else {
        if ($user) {
          console.log("User authenticated, ID:", $user.id);
          const { data: participantData, error: participantError } =
            await supabase
              .from("challenge_participants")
              .select("challenge_id")
              .eq("user_id", $user.id);
          if (participantError) throw participantError;
          const userChallengeIds =
            participantData?.map((p) => p.challenge_id) || [];
          console.log("User's challenge IDs:", userChallengeIds);

          if (userChallengeIds.length > 0) {
            query = query.or(
              `challenge_id.is.null,challenge_id.in.(${userChallengeIds.join(",")})`
            );
            console.log(
              "Querying general posts and user's challenge posts:",
              userChallengeIds
            );
          } else {
            query = query.is("challenge_id", null);
            console.log("No challenges joined, fetching only general posts");
          }

          const { data: whisperData, error: whisperError } = await supabase
            .from("whispers")
            .select("id, sender_id, recipient_id, content, created_at")
            .eq("recipient_id", $user.id)
            .order("created_at", { ascending: false });
          if (whisperError) throw whisperError;
          whispersData = whisperData || [];
          console.log(
            "Fetched whispers:",
            whispersData.length,
            "entries:",
            whispersData
          );
        } else {
          query = query.is("challenge_id", null);
          console.log("Fetching only general posts for unauthenticated user");
        }
      }

      const { data: postData, error: postError } = await query;
      if (postError) throw postError;
      postsData = postData || [];
      console.log("Fetched posts:", postsData.length, "entries:", postsData);

      const userIds = [
        ...new Set(
          [
            ...postsData.map((post) => post.user_id),
            ...whispersData.map((whisper) => whisper.sender_id),
            ...postsData.flatMap((post) =>
              post.post_reactions.map((r) => r.user_id)
            ),
          ].filter((id) => id)
        ),
      ];
      let profilesData = [];
      if (userIds.length > 0) {
        const { data: fetchedProfiles, error: profilesError } = await supabase
          .from("profiles")
          .select("id, first_name, last_name, username, profile_photo_url")
          .in("id", userIds);
        if (profilesError) throw profilesError;
        profilesData = fetchedProfiles || [];
      }
      profilesMap = new Map(profilesData.map((p) => [p.id, p]));
      console.log(
        "Fetched profiles:",
        profilesData.length,
        "entries:",
        profilesData
      );

      const allPosts = [
        ...postsData.map((post) => processPost(post)),
        ...whispersData.map((whisper) => processWhisper(whisper)),
      ];
      posts = buildPostTree(allPosts);
      console.log(
        "Final posts array:",
        posts.map((p) => ({
          id: p.id,
          content: p.content,
          challenge_id: p.challenge_id,
          isWhisper: p.isWhisper,
          comments: p.comments.length,
          first_name: p.first_name,
          last_name: p.last_name,
          username: p.username,
          profile_photo_url: p.profile_photo_url,
        }))
      );
    } catch (err) {
      console.error("Error fetching posts:", err);
      posts = [];
    }
  }

  function processPost(post) {
    let mediaUrl = post.media_url;
    try {
      if (Array.isArray(mediaUrl) && mediaUrl.length > 0) {
        mediaUrl = mediaUrl[0];
      } else if (typeof mediaUrl === "string") {
        mediaUrl = JSON.parse(mediaUrl)[0] || null;
      } else {
        mediaUrl = null;
      }
    } catch (e) {
      mediaUrl = null;
    }
    const profile = post.user_id ? profilesMap.get(post.user_id) : null;
    return {
      ...post,
      timestamp: new Date(post.created_at).toLocaleString("en-US", {
        hour: "numeric",
        minute: "numeric",
        hour12: true,
      }),
      first_name: profile?.first_name || "Anonymous",
      last_name: profile?.last_name || "",
      username: profile?.username || "unknown",
      profile_photo_url: profile?.profile_photo_url || null,
      reactions: post.post_reactions || [],
      media_url: mediaUrl,
      challenge_title: post.challenge_id
        ? post.challenges?.title || "Unknown"
        : "bl0b-general",
      comments: [],
      isWhisper: false,
    };
  }

  function processWhisper(whisper) {
    const profile = whisper.sender_id
      ? profilesMap.get(whisper.sender_id)
      : null;
    return {
      id: whisper.id,
      user_id: whisper.sender_id,
      content: whisper.content,
      created_at: whisper.created_at,
      timestamp: new Date(whisper.created_at).toLocaleString("en-US", {
        hour: "numeric",
        minute: "numeric",
        hour12: true,
      }),
      first_name: profile?.first_name || "Anonymous",
      last_name: profile?.last_name || "",
      username: profile?.username || "unknown",
      profile_photo_url: profile?.profile_photo_url || null,
      reactions: [],
      media_url: null,
      challenge_id: null,
      parent_id: null,
      challenge_title: "Whisper",
      comments: [],
      isWhisper: true,
    };
  }

  async function fetchParticipants() {
    try {
      let participantIds = [];
      if (challengeId) {
        const { data } = await supabase
          .from("challenge_participants")
          .select("user_id")
          .eq("challenge_id", challengeId);
        participantIds = data.map((p) => p.user_id);
      } else if ($user) {
        const { data: friendData } = await supabase
          .from("friends")
          .select("friend_id")
          .eq("user_id", $user.id);
        const { data: participantData } = await supabase
          .from("challenge_participants")
          .select("user_id")
          .eq("user_id", $user.id);
        participantIds = [
          ...new Set([
            ...(friendData?.map((f) => f.friend_id) || []),
            ...(participantData?.map((p) => p.user_id) || []),
            $user.id,
          ]),
        ].filter(Boolean);
      }
      const { data: profilesData } = await supabase
        .from("profiles")
        .select("username")
        .in("id", participantIds);
      participants = profilesData?.map((p) => p.username).filter(Boolean) || [];
      console.log("Participants:", participants);
    } catch (err) {
      console.error("Error fetching participants:", err);
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
    const newPostData = {
      challenge_id: challengeId,
      content: newPost,
      user_id: $user?.id || null,
      media_url: mediaUrl ? [mediaUrl] : null,
      parent_id: null,
      created_at: new Date().toISOString(),
      color_code: "#ffffff",
    };
    const { data, error } = await supabase
      .from("posts")
      .insert([newPostData])
      .select()
      .single();
    if (!error) {
      const processedPost = await processPost(data);
      posts = [processedPost, ...posts];
      newPost = "";
      mediaFiles = [];
      showEmojiPicker = false;
      showGifPicker = false;
      showTagPicker = false;
      console.log("Added new post locally:", processedPost);
    } else {
      console.error("Error submitting post:", error);
    }
  }

  async function submitReply(postId) {
    if (!replyContent.trim()) return;
    const parentPost = posts.find((p) => p.id === postId);
    const parentUsername = parentPost ? parentPost.username : null;
    const finalContent = parentUsername
      ? `@${parentUsername} ${replyContent}`
      : replyContent;
    const newReplyData = {
      challenge_id: challengeId || parentPost?.challenge_id,
      content: finalContent,
      user_id: $user?.id || null,
      media_url: null,
      parent_id: postId,
      created_at: new Date().toISOString(),
      color_code: "#ffffff",
    };
    const { data, error } = await supabase
      .from("posts")
      .insert([newReplyData])
      .select()
      .single();
    if (!error) {
      const processedReply = await processPost(data);
      posts = posts.map((p) =>
        p.id === postId
          ? { ...p, comments: [processedReply, ...p.comments] }
          : p
      );
      replyContent = "";
      replyingTo = null;
      console.log("Added new reply locally:", processedReply);
    } else {
      console.error("Error submitting reply:", error);
    }
  }

  async function toggleReaction(postId, reactionType) {
    const post = posts.find((p) => p.id === postId);
    const existingReaction = post?.reactions.find(
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
    replyingTo = replyingTo === postId ? null : postId;
    if (replyingTo) {
      replyContent = "";
      setTimeout(() => {
        const textarea = document.querySelector(`#reply-${postId} textarea`);
        if (textarea) textarea.focus();
      }, 0);
    }
  }

  function toggleComments(postId) {
    expandedComments[postId] = !expandedComments[postId];
    expandedComments = { ...expandedComments };
    console.log(
      "Toggled comments for post:",
      postId,
      "Expanded:",
      expandedComments[postId]
    );
  }

  function getVisibleComments(post) {
    return expandedComments[post.id]
      ? post.comments
      : post.comments.slice(0, COMMENTS_PER_PAGE);
  }

  function toggleReplies(id) {
    expandedReplies[id] = !expandedReplies[id];
    expandedReplies = { ...expandedReplies };
    console.log(
      "Toggled replies for comment:",
      id,
      "Expanded:",
      expandedReplies[id]
    );
  }
</script>

<div class="feed-container">
  <div class="feed">
    {#each posts.filter((post) => !post.parent_id) as post (post.id)}
      <div class="post">
        <div class="post-header">
          {#if post.profile_photo_url}
            <img
              src={post.profile_photo_url}
              alt={`${post.first_name} ${post.last_name}'s profile`}
              class="profile-pic"
              title="@{post.username}"
              on:click={() => tagUser(post.id, post.username)}
              on:keydown={(e) =>
                handleKeyPress(e, () => tagUser(post.id, post.username))}
            />
          {:else}
            <div
              class="profile-pic-placeholder"
              title="@{post.username}"
              on:click={() => tagUser(post.id, post.username)}
              on:keydown={(e) =>
                handleKeyPress(e, () => tagUser(post.id, post.username))}
            >
              {post.first_name.charAt(0)}{post.last_name.charAt(0)}
            </div>
          {/if}
          <div class="user-info">
            <div class="name-row">
              <span
                class="full-name"
                role="button"
                tabindex="0"
                title="@{post.username}"
                on:click={() => tagUser(post.id, post.username)}
                on:keydown={(e) =>
                  handleKeyPress(e, () => tagUser(post.id, post.username))}
              >
                {post.first_name}
                {post.last_name}
              </span>
              {#if post.challenge_id}
                <a
                  href={`/challenge/${post.challenge_id}`}
                  class="channel-name"
                  on:click|preventDefault={() =>
                    navigate(`/challenge/${post.challenge_id}`)}
                >
                  in #{post.challenge_title}
                </a>
              {:else}
                <span class="channel-name">in #bl0b-general</span>
              {/if}
              {#if post.isWhisper}
                <span class="whisper-label">[Whisper]</span>
              {/if}
            </div>
            <div class="timestamp">{post.timestamp}</div>
          </div>
        </div>
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
                  .map((r) => profilesMap.get(r.user_id)?.username || "unknown")
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
            {#each getVisibleComments(post) as comment (comment.id)}
              <Comment
                {comment}
                level={1}
                {challengeId}
                {currentUserUsername}
                {expandedComments}
                {expandedReplies}
                on:toggleComments={(e) => toggleComments(e.detail.id)}
                on:toggleReplies={(e) => toggleReplies(e.detail.id)}
                on:replySubmitted={fetchPosts}
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
    {#if posts.length === 0}
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
    font-size: clamp(0.75rem, 2.5vw, 0.85rem);
  }
  .post-header {
    display: flex;
    align-items: flex-start;
    gap: 0.5rem;
    margin-bottom: 0.5rem;
  }
  .profile-pic {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    cursor: pointer;
  }
  .profile-pic-placeholder {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    background-color: var(--light-gray);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1rem;
    color: var(--charcoal);
    cursor: pointer;
  }
  .user-info {
    display: flex;
    flex-direction: column;
  }
  .name-row {
    display: flex;
    align-items: baseline;
    gap: 0.5rem;
  }
  .full-name {
    font-size: clamp(0.9rem, 2.5vw, 1rem);
    font-weight: 500;
    color: var(--charcoal);
    cursor: pointer;
  }
  .full-name:hover {
    text-decoration: underline;
  }
  .channel-name {
    font-size: clamp(0.65rem, 2vw, 0.75rem);
    color: var(--dark-moderate-pink);
  }
  .timestamp {
    font-size: clamp(0.6rem, 2vw, 0.7rem);
    color: var(--gray);
    opacity: 0.7;
  }
  .whisper-label {
    font-size: clamp(0.65rem, 2vw, 0.75rem);
    color: var(--tomato);
    font-style: italic;
    margin-left: 0.5rem;
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
  .post-content {
    margin: 0.25rem 0;
    white-space: pre-wrap;
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
