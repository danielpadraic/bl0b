<script>
  import { onMount, onDestroy } from "svelte";
  import { user } from "../stores.js";
  import { supabase } from "../supabase.js";

  export let initialReelId = null;

  let reels = [];
  let currentReelIndex = 0;
  let loading = true;
  let error = null;
  let observer;
  let isLiking = false;

  onMount(async () => {
    await fetchReels();

    // If initialReelId is provided, start with that reel
    if (initialReelId && reels.length > 0) {
      const index = reels.findIndex((reel) => reel.id === initialReelId);
      if (index !== -1) {
        currentReelIndex = index;
      }
    }

    // Set up intersection observer after reels are loaded
    setupIntersectionObserver();

    return () => {
      if (observer) {
        observer.disconnect();
      }
    };
  });

  function setupIntersectionObserver() {
    const options = {
      root: null,
      rootMargin: "0px",
      threshold: 0.8,
    };

    observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        const video = entry.target.querySelector("video");
        if (!video) return;

        if (entry.isIntersecting) {
          const index = parseInt(entry.target.dataset.index);
          if (!isNaN(index)) {
            currentReelIndex = index;
          }
          video.play().catch((err) => console.error("Video play error:", err));
        } else {
          video.pause();
        }
      });
    }, options);

    setTimeout(() => {
      document.querySelectorAll(".reel-container").forEach((reel) => {
        observer.observe(reel);
      });
    }, 100);
  }

  async function fetchReels() {
    try {
      const { data, error: fetchError } = await supabase
        .from("reels")
        .select(
          `
            *,
            profiles:user_id (username, profile_photo_url),
            reel_likes (user_id)
          `
        )
        .order("created_at", { ascending: false });

      if (fetchError) throw fetchError;

      reels = (data || []).map((reel) => ({
        ...reel,
        username: reel.profiles?.username || "Anonymous",
        userPhoto: reel.profiles?.profile_photo_url,
        liked: !!reel.reel_likes?.find((like) => like.user_id === $user?.id),
        likeCount: reel.reel_likes?.length || 0,
      }));

      loading = false;
    } catch (err) {
      console.error("Error fetching reels:", err);
      error = err.message;
      loading = false;
    }
  }

  function handleScroll(event) {
    // Simple implementation: manually controlling which reel is shown
    // based on scroll position
    const container = event.target;
    const reelHeight = container.clientHeight;
    const scrollPosition = container.scrollTop;

    const newIndex = Math.round(scrollPosition / reelHeight);
    if (
      newIndex >= 0 &&
      newIndex < reels.length &&
      newIndex !== currentReelIndex
    ) {
      currentReelIndex = newIndex;
    }
  }

  async function toggleLike(reelId) {
    if (!$user || isLiking) return;

    isLiking = true;
    const reel = reels[currentReelIndex];
    const isLiked = reel.liked;

    try {
      if (isLiked) {
        // Unlike the reel
        await supabase
          .from("reel_likes")
          .delete()
          .eq("user_id", $user.id)
          .eq("reel_id", reelId);

        // Update local state
        reels[currentReelIndex] = {
          ...reel,
          liked: false,
          likeCount: Math.max(0, reel.likeCount - 1),
        };
      } else {
        // Like the reel
        await supabase
          .from("reel_likes")
          .insert([{ user_id: $user.id, reel_id: reelId }]);

        // Update local state
        reels[currentReelIndex] = {
          ...reel,
          liked: true,
          likeCount: reel.likeCount + 1,
        };
      }

      // Force reactivity
      reels = [...reels];
    } catch (err) {
      console.error("Error toggling like:", err);
    } finally {
      isLiking = false;
    }
  }

  function formatCount(count) {
    if (count >= 1000000) {
      return (count / 1000000).toFixed(1) + "M";
    } else if (count >= 1000) {
      return (count / 1000).toFixed(1) + "K";
    }
    return count.toString();
  }
</script>

<div class="reels-player">
  {#if loading}
    <div class="loading">Loading reels...</div>
  {:else if error}
    <div class="error">{error}</div>
  {:else if reels.length === 0}
    <div class="empty-state">No reels available</div>
  {:else}
    <div class="reels-container" on:scroll={handleScroll}>
      {#each reels as reel, index}
        <div class="reel-container" data-index={index}>
          <video
            src={reel.video_url}
            poster={reel.thumbnail_url}
            loop
            preload="metadata"
            playsinline
            class:active={index === currentReelIndex}
          >
            <track kind="captions" label="No captions available" />
          </video>

          <div class="reel-overlay">
            <div class="reel-info">
              <div class="user-info">
                {#if reel.userPhoto}
                  <img
                    src={reel.userPhoto}
                    alt={reel.username}
                    class="user-avatar"
                  />
                {:else}
                  <div class="avatar-placeholder">
                    {reel.username.charAt(0).toUpperCase()}
                  </div>
                {/if}
                <span class="username">@{reel.username}</span>
              </div>
              <p class="caption">{reel.caption}</p>
            </div>

            <div class="reel-actions">
              <button
                class="action-button like-button"
                class:liked={reel.liked}
                on:click={() => toggleLike(reel.id)}
              >
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  width="24"
                  height="24"
                  viewBox="0 0 24 24"
                  fill={reel.liked ? "currentColor" : "none"}
                  stroke="currentColor"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                >
                  <path
                    d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"
                  />
                </svg>
                <span class="count">{formatCount(reel.likeCount)}</span>
              </button>

              <button class="action-button comment-button">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  width="24"
                  height="24"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                >
                  <path
                    d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"
                  />
                </svg>
                <span class="count">
                  {formatCount(reel.comments_count || 0)}
                </span>
              </button>

              <button class="action-button share-button">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  width="24"
                  height="24"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                >
                  <line x1="22" y1="2" x2="11" y2="13" />
                  <polygon points="22 2 15 22 11 13 2 9 22 2" />
                </svg>
              </button>
            </div>
          </div>
        </div>
      {/each}
    </div>
  {/if}
</div>

<style>
  .reels-player {
    width: 100%;
    height: 100%;
    background-color: black;
    position: relative;
    overflow: hidden;
  }

  .reels-container {
    height: 100%;
    overflow-y: scroll;
    scroll-snap-type: y mandatory;
    scroll-behavior: smooth;
  }

  .reel-container {
    height: 100%;
    position: relative;
    scroll-snap-align: start;
    scroll-snap-stop: always;
  }

  video {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  video.active {
    z-index: 2;
  }

  .reel-overlay {
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;
    padding: 20px;
    background: linear-gradient(
      to top,
      rgba(0, 0, 0, 0.7),
      rgba(0, 0, 0, 0) 70%
    );
    display: flex;
    justify-content: space-between;
    z-index: 3;
  }

  .reel-info {
    max-width: 70%;
  }

  .user-info {
    display: flex;
    align-items: center;
    margin-bottom: 8px;
  }

  .user-avatar,
  .avatar-placeholder {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    margin-right: 8px;
  }

  .user-avatar {
    object-fit: cover;
  }

  .avatar-placeholder {
    background-color: var(--carolina-blue);
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-weight: bold;
  }

  .username {
    color: white;
    font-weight: 600;
    text-shadow: 0 1px 3px rgba(0, 0, 0, 0.5);
  }

  .caption {
    color: white;
    text-shadow: 0 1px 3px rgba(0, 0, 0, 0.5);
    margin-top: 0;
    font-size: 0.9rem;
    overflow: hidden;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
  }

  .reel-actions {
    display: flex;
    flex-direction: column;
    justify-content: flex-end;
    gap: 16px;
  }

  .action-button {
    background: none;
    border: none;
    color: white;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 4px;
    cursor: pointer;
  }

  .action-button svg {
    filter: drop-shadow(0 1px 3px rgba(0, 0, 0, 0.5));
  }

  .like-button.liked {
    color: var(--tomato);
  }

  .count {
    font-size: 0.8rem;
    font-weight: 600;
    text-shadow: 0 1px 3px rgba(0, 0, 0, 0.5);
  }

  .loading,
  .error,
  .empty-state {
    display: flex;
    height: 100%;
    align-items: center;
    justify-content: center;
    color: white;
    text-align: center;
    padding: 20px;
  }

  .error {
    color: var(--tomato);
  }
</style>
