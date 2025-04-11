<script>
  import { onMount } from "svelte";
  import { navigate } from "svelte-routing";
  import { user } from "../stores.js";
  import { supabase } from "../supabase.js";

  let stories = [];
  let loading = true;

  onMount(async () => {
    await fetchStories();
    loading = false;
  });

  async function fetchStories() {
    try {
      // In a real app, you'd fetch stories from supabase
      // For this example, we'll create sample data

      // Simulate API fetch with timeout
      await new Promise((resolve) => setTimeout(resolve, 300));

      // Create user's "Create Story" card first in the list (if logged in)
      if ($user) {
        stories = [
          {
            id: "create",
            isCreateCard: true,
            user_id: $user.id,
            profile_image: null, // Will use placeholder in UI
          },
        ];
      } else {
        stories = [];
      }

      // Sample stories data
      const sampleStories = [
        {
          id: 1,
          user_id: "sample-user-1",
          username: "john_runner",
          profile_image: "https://via.placeholder.com/150",
          story_image: "https://via.placeholder.com/300",
          viewed: false,
          created_at: new Date().toISOString(),
        },
        {
          id: 2,
          user_id: "sample-user-2",
          username: "fitness_enthusiast",
          profile_image: "https://via.placeholder.com/150",
          story_image: "https://via.placeholder.com/300",
          viewed: true,
          created_at: new Date().toISOString(),
        },
        {
          id: 3,
          user_id: "sample-user-3",
          username: "yoga_daily",
          profile_image: "https://via.placeholder.com/150",
          story_image: "https://via.placeholder.com/300",
          viewed: false,
          created_at: new Date().toISOString(),
        },
        {
          id: 4,
          user_id: "sample-user-4",
          username: "marathon_prep",
          profile_image: "https://via.placeholder.com/150",
          story_image: "https://via.placeholder.com/300",
          viewed: false,
          created_at: new Date().toISOString(),
        },
        {
          id: 5,
          user_id: "sample-user-5",
          username: "daily_stretch",
          profile_image: "https://via.placeholder.com/150",
          story_image: "https://via.placeholder.com/300",
          viewed: true,
          created_at: new Date().toISOString(),
        },
      ];

      stories = [...stories, ...sampleStories];
    } catch (err) {
      console.error("Error fetching stories:", err);
      stories = [];
    }
  }

  function handleStoryClick(story) {
    if (story.isCreateCard) {
      if ($user) {
        navigate("/create-story");
      } else {
        navigate("/login");
      }
    } else {
      navigate(`/story/${story.id}`);
    }
  }
</script>

<section class="stories-section">
  {#if loading}
    <div class="loading-container">
      <div class="skeleton-loader"></div>
      <div class="skeleton-loader"></div>
      <div class="skeleton-loader"></div>
      <div class="skeleton-loader"></div>
    </div>
  {:else if stories.length === 0}
    <div class="empty-state">
      <p>No stories available</p>
    </div>
  {:else}
    <div class="stories-carousel">
      {#each stories as story}
        <div
          class="story-card"
          class:create-card={story.isCreateCard}
          tabindex="0"
          role="button"
          on:click={() => handleStoryClick(story)}
          on:keydown={(e) => {
            if (e.key === "Enter" || e.key === "Space") {
              e.preventDefault();
              handleStoryClick(story);
            }
          }}
        >
          <div
            class="story-avatar-container"
            class:viewed={story.viewed && !story.isCreateCard}
          >
            {#if story.isCreateCard}
              <div class="create-avatar">
                <div class="create-avatar-inner">
                  <span class="create-icon">+</span>
                </div>
              </div>
            {:else}
              <img
                src={story.profile_image}
                alt={story.username}
                class="story-avatar"
              />
            {/if}
          </div>
          <span class="story-username">
            {story.isCreateCard ? "Create Story" : story.username}
          </span>
        </div>
      {/each}
    </div>
  {/if}
</section>

<style>
  .stories-section {
    margin: 0;
    padding: 12px 0;
    background-color: white;
    border-bottom: 1px solid var(--light-gray);
  }

  .stories-carousel {
    display: flex;
    overflow-x: auto;
    scroll-snap-type: x mandatory;
    gap: 12px;
    padding: 0 12px;
    -webkit-overflow-scrolling: touch; /* Smooth scrolling on iOS */
    scrollbar-width: none; /* Hide scrollbar for Firefox */
  }

  /* Hide scrollbar for Chrome/Safari */
  .stories-carousel::-webkit-scrollbar {
    display: none;
  }

  .story-card {
    flex: 0 0 auto;
    display: flex;
    flex-direction: column;
    align-items: center;
    width: 76px;
    scroll-snap-align: start;
    cursor: pointer;
  }

  .story-avatar-container {
    width: 68px;
    height: 68px;
    border-radius: 50%;
    background: linear-gradient(45deg, #f58a6c, #f26440);
    padding: 2px;
    margin-bottom: 4px;
  }

  .story-avatar-container.viewed {
    background: var(--light-gray);
  }

  .story-avatar {
    width: 100%;
    height: 100%;
    border-radius: 50%;
    object-fit: cover;
    border: 3px solid white;
    box-sizing: border-box;
  }

  .create-avatar {
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .create-avatar-inner {
    width: 92%;
    height: 92%;
    border-radius: 50%;
    background-color: var(--light-gray);
    display: flex;
    align-items: center;
    justify-content: center;
    border: 3px solid white;
    box-sizing: border-box;
  }

  .create-icon {
    font-size: 26px;
    color: var(--charcoal);
    font-weight: bold;
  }

  .story-username {
    font-size: 12px;
    text-align: center;
    color: var(--charcoal);
    max-width: 70px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  /* Loading animation */
  .loading-container {
    display: flex;
    gap: 12px;
    padding: 0 12px;
  }

  .skeleton-loader {
    flex: 0 0 auto;
    width: 76px;
    height: 100px;
  }

  .skeleton-loader::before {
    content: "";
    display: block;
    width: 68px;
    height: 68px;
    margin: 0 auto 8px;
    border-radius: 50%;
    background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
    background-size: 200% 100%;
    animation: shimmer 1.5s infinite;
  }

  .skeleton-loader::after {
    content: "";
    display: block;
    width: 60px;
    height: 12px;
    margin: 0 auto;
    border-radius: 6px;
    background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
    background-size: 200% 100%;
    animation: shimmer 1.5s infinite;
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
    text-align: center;
  }

  .empty-state p {
    color: var(--gray);
    margin: 0;
  }
</style>
