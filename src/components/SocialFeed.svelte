<script>
  import { onMount, onDestroy } from "svelte";
  import { supabase } from "../supabase.js";
  import { user } from "../stores.js";
  import { navigate } from "svelte-routing";
  import Comment from "./Comment.svelte";
  import { writable } from "svelte/store";

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

  // Create a Svelte store for profilesMap to ensure proper reactivity
  let profilesMapStore = writable(new Map());
  $: profilesMap = $profilesMapStore;

  const GIPHY_API_KEY = "lGJJOnOXxAtmYy5GaKCId3RDdah90xaG";
  const COMMENTS_PER_PAGE = 3;

  // Function to load the current user's profile
  async function loadCurrentUserProfile() {
    if (!$user || !$user.id) {
      console.log("No user logged in, skipping profile load");
      currentUserUsername = "Anonymous";
      return;
    }

    try {
      console.log("Fetching current user profile for ID:", $user.id);

      const { data, error } = await supabase
        .from("profiles")
        .select("id, username, first_name, last_name, profile_photo_url")
        .eq("id", $user.id)
        .single();

      if (error) {
        console.error("Error fetching user profile:", error);
        return;
      }

      if (data) {
        console.log("Successfully loaded user profile:", data);
        currentUserUsername = data.username || "Anonymous";

        // Update the store to trigger reactivity
        profilesMapStore.update((map) => {
          const newMap = new Map(map);
          newMap.set($user.id, data);
          console.log("Updated profilesMapStore with current user data");
          return newMap;
        });

        // If there's a profile photo URL, verify it loads correctly
        if (data.profile_photo_url) {
          console.log("Verifying profile photo URL:", data.profile_photo_url);

          // Create a new image to test loading
          const img = new Image();
          img.onload = () => {
            console.log("Profile image loaded successfully");
          };

          img.onerror = () => {
            console.error(
              "Failed to load profile image:",
              data.profile_photo_url
            );
            // Update the store with null profile photo on error
            profilesMapStore.update((map) => {
              const newMap = new Map(map);
              newMap.set($user.id, {
                ...data,
                profile_photo_url: null,
              });
              return newMap;
            });
          };

          img.src = data.profile_photo_url;
        }
      } else {
        console.log("No user profile data found");
        currentUserUsername = "Anonymous";
      }
    } catch (err) {
      console.error("Error in loadCurrentUserProfile:", err);
      currentUserUsername = "Anonymous";
    }
  }

  onMount(async () => {
    console.log(
      "SocialFeed mounted with challengeId:",
      challengeId,
      "challengeName:",
      challengeName
    );
    console.log("Current user ID:", $user?.id);

    // Initialize profilesMap store
    profilesMapStore.set(new Map());

    // First, load the current user's profile
    if ($user) {
      await loadCurrentUserProfile();
    }

    // Then continue with other loading operations
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
            // Always include current user ID
            $user?.id,
          ].filter((id) => id) // Filter out null user_ids
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

        // Update the profilesMapStore to trigger reactivity
        profilesMapStore.update((map) => {
          const newMap = new Map(map);

          // Add all fetched profiles to the map
          profilesData.forEach((profile) => {
            // Don't overwrite the current user's profile if it's already in the map
            if (!newMap.has(profile.id) || profile.id !== $user?.id) {
              newMap.set(profile.id, profile);
            }
          });

          return newMap;
        });
      }

      console.log(
        "Fetched profiles:",
        profilesData.length,
        "entries:",
        profilesData
      );

      const processedPosts = await Promise.all(
        postsData.map((post) => processPost(post))
      );
      const processedWhispers = await Promise.all(
        whispersData.map((whisper) => processWhisper(whisper))
      );

      const allPosts = [...processedPosts, ...processedWhispers];
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
          isAutomated: p.isAutomated,
        }))
      );
    } catch (err) {
      console.error("Error fetching posts:", err);
      posts = [];
    }
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

  function processPost(post) {
    let mediaUrl = post.media_url;
    try {
      if (Array.isArray(mediaUrl) && mediaUrl.length > 0) {
        mediaUrl = mediaUrl[0];
      } else if (typeof mediaUrl === "string") {
        try {
          mediaUrl = JSON.parse(mediaUrl)[0] || null;
        } catch (e) {
          mediaUrl = mediaUrl; // Keep as is if it's not JSON
        }
      } else {
        mediaUrl = null;
      }
    } catch (e) {
      mediaUrl = null;
    }

    // Use the reactive profilesMap derived from profilesMapStore
    const profile =
      post.user_id && profilesMap ? profilesMap.get(post.user_id) : null;
    const isAutomated = post.user_id === null; // Automated posts have null user_id

    // Make sure we're not returning undefined for profile_photo_url
    const photoUrl =
      profile && profile.profile_photo_url ? profile.profile_photo_url : null;

    return {
      ...post,
      timestamp: new Date(post.created_at).toLocaleString("en-US", {
        hour: "numeric",
        minute: "numeric",
        hour12: true,
      }),
      first_name: isAutomated ? "Bob" : profile?.first_name || "Anonymous",
      last_name: isAutomated ? "leBlob" : profile?.last_name || "",
      username: isAutomated ? "bob_leblob" : profile?.username || "unknown",
      profile_photo_url: isAutomated ? null : photoUrl,
      reactions: post.post_reactions || [],
      media_url: mediaUrl,
      challenge_title: post.challenge_id
        ? post.challenges?.title || "Unknown"
        : "bl0b-general",
      comments: [],
      isWhisper: false,
      isAutomated: isAutomated,
    };
  }

  function processWhisper(whisper) {
    // Use the reactive profilesMap derived from profilesMapStore
    const profile =
      whisper.sender_id && profilesMap
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
      isAutomated: false,
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
  <!-- Post Form positioned at the top of the feed -->
  <div class="post-form-container">
    <div class="input-container">
      {#if $user && $user.id}
        {#if profilesMap && profilesMap.has($user.id) && profilesMap.get($user.id).profile_photo_url}
          <!-- User has a profile photo -->
          <img
            src={profilesMap.get($user.id).profile_photo_url}
            alt="Your profile"
            class="user-avatar"
          />
        {:else}
          <!-- Show initials if no profile photo -->
          <div class="user-avatar-placeholder">
            {#if profilesMap && profilesMap.has($user.id)}
              {profilesMap.get($user.id).first_name
                ? profilesMap.get($user.id).first_name.charAt(0)
                : ""}
              {profilesMap.get($user.id).last_name
                ? profilesMap.get($user.id).last_name.charAt(0)
                : ""}
            {:else}
              ?
            {/if}
          </div>
        {/if}
      {:else}
        <!-- User not logged in -->
        <div class="user-avatar-placeholder">?</div>
      {/if}

      <textarea
        bind:value={newPost}
        on:input={handleInput}
        on:keydown={(e) => handleKeydown(e, null)}
        placeholder="Share what's on your mind..."
        rows="2"
      ></textarea>

      <button class="send-btn" on:click={submitPost} disabled={!$user}>
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="16"
          height="16"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
        >
          <line x1="22" y1="2" x2="11" y2="13"></line>
          <polygon points="22 2 15 22 11 13 2 9 22 2"></polygon>
        </svg>
      </button>
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
        title="Upload Image"
        class="toolbar-btn"
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="20"
          height="20"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
        >
          <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
          <circle cx="8.5" cy="8.5" r="1.5" />
          <polyline points="21 15 16 10 5 21" />
        </svg>
      </button>
      <input
        id="mediaInput"
        type="file"
        accept="image/*"
        on:change={handleMediaChange}
        hidden
      />
      <button
        type="button"
        on:click={() => document.getElementById("videoInput").click()}
        title="Upload Video"
        class="toolbar-btn"
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="20"
          height="20"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
        >
          <polygon points="23 7 16 12 23 17 23 7" />
          <rect x="1" y="5" width="15" height="14" rx="2" ry="2" />
        </svg>
      </button>
      <input
        id="videoInput"
        type="file"
        accept="video/*"
        on:change={handleMediaChange}
        hidden
      />
      <button
        type="button"
        on:click={() => (showGifPicker = !showGifPicker)}
        title="Add GIF"
        class="toolbar-btn gif-btn"
      >
        <span class="gif-text">GIF</span>
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
  </div>

  <!-- Debug button - can be removed once everything is working properly -->
  {#if $user && $user.id}
    <button
      class="debug-button"
      on:click={() => {
        console.log("Current user:", $user);
        console.log(
          "ProfilesMap has user?",
          profilesMap && profilesMap.has($user.id)
        );
        if (profilesMap && profilesMap.has($user.id)) {
          console.log("User in profilesMap:", profilesMap.get($user.id));
          console.log(
            "Profile photo URL:",
            profilesMap.get($user.id).profile_photo_url
          );
        }

        // Trigger a manual reload of the profile
        loadCurrentUserProfile();
      }}
    >
      Debug Profile
    </button>
  {/if}

  <div class="feed">
    {#each posts.filter((post) => !post.parent_id) as post (post.id)}
      <div class="post" class:automated={post.isAutomated}>
        <div class="post-header">
          {#if post.profile_photo_url && !post.isAutomated}
            <img
              src={post.profile_photo_url}
              alt={`${post.first_name} ${post.last_name}'s profile`}
              class="profile-pic"
              title="@{post.username}"
              on:click={() => tagUser(post.id, post.username)}
              on:keydown={(e) =>
                handleKeyPress(e, () => tagUser(post.id, post.username))}
            />
          {:else if !post.isAutomated}
            <div
              class="profile-pic-placeholder"
              title="@{post.username}"
              on:click={() => tagUser(post.id, post.username)}
              on:keydown={(e) =>
                handleKeyPress(e, () => tagUser(post.id, post.username))}
            >
              {post.first_name.charAt(0)}{post.last_name.charAt(0)}
            </div>
          {:else}
            <div class="system-icon">📢</div>
          {/if}
          <div class="user-info">
            <div class="name-row">
              <span
                class="full-name"
                class:automated-name={post.isAutomated}
                role="button"
                tabindex="0"
                title="@{post.username}"
                on:click={() =>
                  !post.isAutomated && tagUser(post.id, post.username)}
                on:keydown={(e) =>
                  !post.isAutomated &&
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
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="16"
              height="16"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
              <circle cx="12" cy="12" r="10" />
              <path d="M8 14s1.5 2 4 2 4-2 4-2" />
              <line x1="9" y1="9" x2="9.01" y2="9" />
              <line x1="15" y1="9" x2="15.01" y2="9" />
            </svg>
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
                  .map(
                    (r) =>
                      (profilesMap && profilesMap.get(r.user_id)?.username) ||
                      "unknown"
                  )
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
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="16"
              height="16"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
              <path
                d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"
              />
            </svg>
            <span>Comment</span>
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
            <button class="send-btn" on:click={() => submitReply(post.id)}>
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="14"
                height="14"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round"
              >
                <line x1="22" y1="2" x2="11" y2="13"></line>
                <polygon points="22 2 15 22 11 13 2 9 22 2"></polygon>
              </svg>
            </button>
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
      <p class="empty-message">
        No posts yet. Be the first to share something!
      </p>
    {/if}
  </div>
</div>

<style>
  .feed-container {
    display: flex;
    flex-direction: column;
    max-width: 600px;
    width: 100%;
    margin: 0 auto;
    position: relative;
    z-index: 20;
  }

  /* Post form container at the top */
  .post-form-container {
    background-color: white;
    border-radius: 12px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    padding: 12px;
    margin-bottom: 16px;
    position: relative;
    z-index: 30;
  }

  .input-container {
    position: relative;
    display: flex;
    align-items: center;
  }

  textarea {
    width: 100%;
    resize: none;
    border: 1px solid var(--light-gray);
    border-radius: 20px;
    padding: 12px 40px 12px 16px;
    font-size: 14px;
    background-color: var(--light-gray);
    transition:
      background-color 0.2s,
      border-color 0.2s;
  }

  textarea:focus {
    outline: none;
    background-color: white;
    border-color: var(--carolina-blue);
  }

  .send-btn {
    position: absolute;
    right: 8px;
    bottom: 50%;
    transform: translateY(50%);
    padding: 8px;
    background-color: var(--tomato);
    color: white;
    border: none;
    border-radius: 50%;
    width: 30px;
    height: 30px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 14px;
    cursor: pointer;
    transition: background-color 0.2s;
  }

  .send-btn:hover {
    background-color: var(--tomato-light);
  }

  .send-btn:disabled {
    background-color: var(--gray);
    cursor: not-allowed;
  }

  .toolbar {
    display: flex;
    padding-top: 8px;
    gap: 12px;
  }

  .toolbar-btn {
    background: none;
    border: none;
    color: var(--gray);
    padding: 8px;
    border-radius: 50%;
    cursor: pointer;
    transition:
      background-color 0.2s,
      color 0.2s;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .toolbar-btn:hover {
    background-color: var(--light-gray);
    color: var(--tomato);
  }

  /* Feed content styling */
  .feed {
    display: flex;
    flex-direction: column;
    gap: 16px;
  }

  .post {
    background-color: white;
    border-radius: 12px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
    padding: 16px;
    transition: transform 0.2s;
  }

  .post:hover {
    transform: translateY(-2px);
  }

  .post.automated {
    background-color: #f0f8ff;
    border-left: 4px solid var(--carolina-blue);
  }

  .post-header {
    display: flex;
    align-items: flex-start;
    gap: 12px;
    margin-bottom: 12px;
  }

  .profile-pic {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    object-fit: cover;
    cursor: pointer;
  }

  .profile-pic-placeholder {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background-color: var(--light-gray);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 16px;
    font-weight: 500;
    color: var(--charcoal);
    cursor: pointer;
  }

  .system-icon {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background-color: var(--carolina-blue);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 20px;
    color: white;
  }

  .user-info {
    flex: 1;
  }

  .name-row {
    display: flex;
    align-items: baseline;
    flex-wrap: wrap;
    gap: 8px;
    margin-bottom: 2px;
  }

  .full-name {
    font-weight: 600;
    color: var(--charcoal);
    font-size: 15px;
    cursor: pointer;
  }

  .full-name.automated-name {
    color: var(--charcoal);
    font-weight: bold;
    cursor: default;
  }

  .full-name:hover:not(.automated-name) {
    text-decoration: underline;
  }

  .channel-name {
    font-size: 13px;
    color: var(--tomato);
    text-decoration: none;
  }

  .channel-name:hover {
    text-decoration: underline;
  }

  .timestamp {
    font-size: 12px;
    color: var(--gray);
  }

  .whisper-label {
    font-size: 12px;
    color: var(--tomato);
    font-style: italic;
  }

  .post-content {
    margin-bottom: 12px;
    white-space: pre-wrap;
    font-size: 14px;
    line-height: 1.5;
  }

  .media {
    margin-bottom: 12px;
    border-radius: 8px;
    overflow: hidden;
  }

  .media img,
  .media video {
    width: 100%;
    max-height: 400px;
    object-fit: contain;
    background-color: #f5f5f5;
    border-radius: 8px;
  }

  .reactions {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-top: 4px;
    position: relative;
  }

  .reaction-btn {
    background: none;
    border: none;
    color: var(--gray);
    font-size: 14px;
    padding: 4px 8px;
    border-radius: 4px;
    cursor: pointer;
    display: flex;
    align-items: center;
  }

  .reaction-btn:hover {
    background-color: var(--light-gray);
    color: var(--charcoal);
  }

  .reaction-count {
    background-color: var(--light-gray);
    color: var(--charcoal);
    font-size: 12px;
    padding: 4px 8px;
    border-radius: 12px;
    cursor: pointer;
  }

  .reaction-count:hover {
    background-color: #e0e0e0;
  }

  .comment-link {
    margin-left: auto;
    color: var(--gray);
    text-decoration: none;
    font-size: 13px;
    font-weight: 500;
    display: flex;
    align-items: center;
    gap: 4px;
  }

  .comment-link:hover {
    color: var(--tomato);
  }

  .reply-form {
    margin-top: 12px;
    display: flex;
    align-items: center;
    position: relative;
  }

  .reply-form textarea {
    border-radius: 16px;
    padding: 8px 40px 8px 12px;
    font-size: 13px;
  }

  .reaction-picker {
    position: absolute;
    bottom: 100%;
    left: 0;
    background-color: white;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    padding: 8px;
    display: flex;
    gap: 8px;
    z-index: 10;
  }

  .reaction-picker button {
    background: none;
    border: none;
    font-size: 18px;
    cursor: pointer;
    padding: 4px;
    border-radius: 4px;
    transition:
      transform 0.2s,
      background-color 0.2s;
  }

  .reaction-picker button:hover {
    transform: scale(1.2);
    background-color: var(--light-gray);
  }

  .comments {
    margin-top: 16px;
    border-top: 1px solid var(--light-gray);
    padding-top: 12px;
  }

  .view-more-link {
    display: block;
    margin-top: 8px;
    color: var(--tomato);
    text-decoration: none;
    font-size: 13px;
    font-weight: 500;
  }

  .view-more-link:hover {
    text-decoration: underline;
  }

  .tag-picker {
    position: absolute;
    background: white;
    border: 1px solid var(--light-gray);
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    max-height: 200px;
    overflow-y: auto;
    z-index: 100;
    width: 200px;
  }

  .tag-suggestion {
    padding: 8px 12px;
    cursor: pointer;
    transition: background-color 0.2s;
  }

  .tag-suggestion:hover {
    background-color: var(--light-gray);
  }

  .user-avatar,
  .user-avatar-placeholder {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    margin-right: 12px;
    flex-shrink: 0;
  }

  .user-avatar {
    object-fit: cover;
  }

  .user-avatar-placeholder {
    background-color: var(--light-gray);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 16px;
    font-weight: 500;
    color: var(--charcoal);
  }

  .gif-btn {
    font-size: 13px;
    font-weight: 700;
    background-color: transparent;
    border-radius: 4px;
    padding: 4px 8px;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .gif-text {
    letter-spacing: 0.5px;
  }

  .gif-btn:hover {
    color: var(--tomato);
    border-color: var(--tomato);
  }

  .gif-picker {
    position: absolute;
    background: white;
    border: 1px solid var(--light-gray);
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    z-index: 100;
    margin-top: 4px;
    width: 300px;
    max-height: 300px;
    padding: 12px;
  }

  .gif-picker input {
    width: 100%;
    padding: 8px 12px;
    border: 1px solid var(--light-gray);
    border-radius: 8px;
    margin-bottom: 8px;
  }

  .gif-list {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 8px;
    max-height: 200px;
    overflow-y: auto;
  }

  .gif-button {
    padding: 0;
    border: none;
    background: none;
    cursor: pointer;
    border-radius: 4px;
    overflow: hidden;
  }

  .gif-button img {
    width: 100%;
    height: auto;
    transition: transform 0.2s;
  }

  .gif-button:hover img {
    transform: scale(1.05);
  }

  .emoji-picker {
    display: flex;
    flex-wrap: wrap;
    padding: 8px;
    gap: 8px;
    max-width: 300px;
    position: absolute;
    background: white;
    border: 1px solid var(--light-gray);
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    z-index: 100;
    margin-top: 4px;
  }

  .emoji-button {
    font-size: 20px;
    padding: 6px;
    border: none;
    background: none;
    cursor: pointer;
    border-radius: 4px;
    transition:
      transform 0.2s,
      background-color 0.2s;
  }

  .emoji-button:hover {
    transform: scale(1.2);
    background-color: var(--light-gray);
  }

  .empty-message {
    text-align: center;
    padding: 20px;
    color: var(--gray);
    font-size: 14px;
    background-color: white;
    border-radius: 12px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  }

  /* Debug button styling */
  .debug-button {
    margin: 0 auto 16px;
    padding: 6px 12px;
    font-size: 12px;
    background-color: #f0f0f0;
    color: #333;
    border: 1px solid #ccc;
    border-radius: 4px;
    cursor: pointer;
  }

  .debug-button:hover {
    background-color: #e0e0e0;
  }

  /* Responsive adjustments */
  @media (max-width: 768px) {
    .post {
      border-radius: 0;
      margin-left: -16px;
      margin-right: -16px;
      width: calc(100% + 32px);
    }
  }
</style>
