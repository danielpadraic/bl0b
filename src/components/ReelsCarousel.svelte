<script>
  import { onMount } from "svelte";
  import { navigate } from "svelte-routing";
  import { user } from "../stores.js";
  import { supabase } from "../supabase.js";

  let reels = [];
  let loading = true;

  onMount(async () => {
    await fetchReels();
    loading = false;
  });

  async function fetchReels() {
    try {
      // In a real app, you'd fetch reels from supabase, but for this example we'll create sample data

      // Simulate API fetch with timeout
      await new Promise((resolve) => setTimeout(resolve, 500));

      reels = [
        {
          id: 1,
          user_id: "sample-user-1",
          username: "fitness_coach",
          profile_image: "https://via.placeholder.com/150",
          video_url: "https://via.placeholder.com/200x350",
          thumbnail: "https://via.placeholder.com/200x350",
          title: "Morning HIIT Workout",
          views: 1250,
          likes: 342,
          duration: "0:30",
        },
        {
          id: 2,
          user_id: "sample-user-2",
          username: "yoga_master",
          profile_image: "https://via.placeholder.com/150",
          video_url: "https://via.placeholder.com/200x350",
          thumbnail: "https://via.placeholder.com/200x350",
          title: "10-Min Yoga Flow",
          views: 986,
          likes: 201,
          duration: "0:45",
        },
        {
          id: 3,
          user_id: "sample-user-3",
          username: "run_daily",
          profile_image: "https://via.placeholder.com/150",
          video_url: "https://via.placeholder.com/200x350",
          thumbnail: "https://via.placeholder.com/200x350",
          title: "5K Training Tips",
          views: 1823,
          likes: 529,
          duration: "1:00",
        },
        {
          id: 4,
          user_id: "sample-user-4",
          username: "fitness_mom",
          profile_image: "https://via.placeholder.com/150",
          video_url: "https://via.placeholder.com/200x350",
          thumbnail: "https://via.placeholder.com/200x350",
          title: "Home Workout Challenge",
          views: 3210,
          likes: 782,
          duration: "0:50",
        },
        {
          id: 5,
          user_id: "sample-user-5",
          username: "weight_trainer",
          profile_image: "https://via.placeholder.com/150",
          video_url: "https://via.placeholder.com/200x350",
          thumbnail: "https://via.placeholder.com/200x350",
          title: "Proper Form Guide",
          views: 2109,
          likes: 673,
          duration: "1:15",
        },
      ];
    } catch (err) {
      console.error("Error fetching reels:", err);
      reels = [];
    }
  }

  function handleReelClick(reelId) {
    // Navigate to reel detail page
    navigate(`/reels/${reelId}`);
  }
</script>

<section class="reels-section">
  <div class="section-header">
    <h2>Reels</h2>
    <a href="/reels" class="see-all">See All</a>
  </div>

  {#if loading}
    <div class="loading-container">
      <div class="skeleton-loader"></div>
      <div class="skeleton-loader"></div>
      <div class="skeleton-loader"></div>
    </div>
  {:else if reels.length === 0}
    <div class="empty-state">
      <p>No reels available right now</p>
    </div>
  {:else}
    <div class="reels-carousel">
      {#each reels as reel}
        <div
          class="reel-card"
          tabindex="0"
          role="button"
          on:click={() => handleReelClick(reel.id)}
          on:keydown={(e) => {
            if (e.key === "Enter" || e.key === "Space") {
              e.preventDefault();
              handleReelClick(reel.id);
            }
          }}
        >
          <div class="reel-thumbnail">
            <img src={reel.thumbnail} alt={reel.title} />
            <div class="reel-duration">{reel.duration}</div>
            <div class="play-button">▶</div>
          </div>
          <div class="reel-info">
            <div class="reel-user">
              <img
                src={reel.profile_image}
                alt={reel.username}
                class="user-avatar"
              />
              <span class="username">@{reel.username}</span>
            </div>
            <div class="reel-title">{reel.title}</div>
            <div class="reel-stats">
              <span>{reel.views} views</span>
              <span>{reel.likes} likes</span>
            </div>
          </div>
        </div>
      {/each}
    </div>
  {/if}
</section>

<style>
  .reels-section {
    margin: 16px 0;
    padding: 0 16px;
  }

  .section-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 12px;
  }

  .section-header h2 {
    font-size: 1.25rem;
    color: var(--charcoal);
    margin: 0;
    font-weight: 600;
  }

  .see-all {
    color: var(--tomato);
    text-decoration: none;
    font-size: 0.9rem;
    font-weight: 500;
  }

  .reels-carousel {
    display: flex;
    overflow-x: auto;
    scroll-snap-type: x mandatory;
    gap: 12px;
    padding-bottom: 8px;
    -webkit-overflow-scrolling: touch; /* Smooth scrolling on iOS */
    scrollbar-width: none; /* Hide scrollbar for Firefox */
  }

  /* Hide scrollbar for Chrome/Safari */
  .reels-carousel::-webkit-scrollbar {
    display: none;
  }

  .reel-card {
    flex: 0 0 auto;
    width: 200px;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    scroll-snap-align: start;
    background: white;
    cursor: pointer;
    transition: transform 0.2s ease;
  }

  .reel-card:hover {
    transform: scale(1.02);
  }

  .reel-thumbnail {
    height: 270px;
    position: relative;
    overflow: hidden;
  }

  .reel-thumbnail img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  .reel-duration {
    position: absolute;
    bottom: 8px;
    right: 8px;
    background-color: rgba(0, 0, 0, 0.7);
    color: white;
    padding: 1px 6px;
    border-radius: 4px;
    font-size: 0.75rem;
  }

  .play-button {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    width: 50px;
    height: 50px;
    background-color: rgba(255, 255, 255, 0.3);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 1.5rem;
    text-shadow: 0 0 3px rgba(0, 0, 0, 0.5);
  }

  .reel-info {
    padding: 10px;
  }

  .reel-user {
    display: flex;
    align-items: center;
    margin-bottom: 4px;
  }

  .user-avatar {
    width: 24px;
    height: 24px;
    border-radius: 50%;
    margin-right: 6px;
  }

  .username {
    font-size: 0.85rem;
    color: var(--charcoal);
    font-weight: 500;
  }

  .reel-title {
    font-size: 0.9rem;
    font-weight: 500;
    color: var(--text);
    margin-bottom: 4px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .reel-stats {
    display: flex;
    justify-content: space-between;
    font-size: 0.75rem;
    color: var(--gray);
  }

  /* Loading animation */
  .loading-container {
    display: flex;
    gap: 12px;
    overflow-x: auto;
  }

  .skeleton-loader {
    flex: 0 0 auto;
    width: 200px;
    height: 324px;
    background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
    background-size: 200% 100%;
    animation: shimmer 1.5s infinite;
    border-radius: 12px;
  }

  @keyframes shimmer {
    0% {
      background-position: 200% 0;
    }
    100% {
      background-position: -200% 0;
    }
  }

  .empty-state {
    padding: 20px;
    background-color: var(--light-gray);
    border-radius: 12px;
    text-align: center;
  }

  .empty-state p {
    color: var(--gray);
    margin: 0;
  }
</style>
