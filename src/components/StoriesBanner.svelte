<script>
  import { onMount } from "svelte";
  import { navigate } from "svelte-routing";
  import { user } from "../stores.js";
  import { supabase } from "../supabase.js";

  let stories = [];
  let loading = true;
  let userProfile = null;

  onMount(async () => {
    console.log("StoriesBanner mounted, current user:", $user);

    // Get user profile information if logged in
    if ($user && $user.id) {
      try {
        const { data, error } = await supabase
          .from("profiles")
          .select("username, profile_photo_url")
          .eq("id", $user.id)
          .single();

        if (!error && data) {
          userProfile = data;
          console.log("User profile loaded:", userProfile);
        } else {
          console.error("Error loading user profile:", error);
        }
      } catch (err) {
        console.error("Error in user profile fetch:", err);
      }
    }

    await fetchStories();
    loading = false;
  });

  async function fetchStories() {
    try {
      // Get the current time to filter out expired stories
      const now = new Date().toISOString();

      // First, create a query for active stories (not expired)
      let query = supabase
        .from("stories")
        .select(
          `
          id, 
          user_id, 
          created_at,
          profiles(username, profile_photo_url),
          story_views(user_id)
        `
        )
        .gt("expires_at", now) // Only show stories that haven't expired
        .order("created_at", { ascending: false });

      const { data, error } = await query;

      if (error) throw error;

      console.log("Stories data from Supabase:", data);

      // Process the stories to get the final format we need
      const processedStories = [];
      const uniqueUsers = new Map();

      // First, organize stories by user
      if (data && data.length > 0) {
        data.forEach((story) => {
          const userId = story.user_id;
          const profileData = story.profiles || {};
          const viewData = story.story_views || [];

          // Has current user viewed this story?
          const viewed = $user
            ? viewData.some((view) => view.user_id === $user.id)
            : false;

          if (!uniqueUsers.has(userId)) {
            uniqueUsers.set(userId, {
              id: userId,
              username: profileData.username || "Anonymous",
              profile_photo_url: profileData.profile_photo_url,
              stories: [],
              viewed: true, // Will be set to false if any story is unviewed
            });
          }

          // Add to the user's stories
          const userStories = uniqueUsers.get(userId);
          userStories.stories.push({
            id: story.id,
            created_at: story.created_at,
            viewed: viewed,
          });

          // If any story is unviewed, mark the user as having unviewed stories
          if (!viewed) {
            userStories.viewed = false;
          }
        });
      }

      // Create "Add Story" card for current user if they're logged in
      if ($user) {
        console.log("Adding create story card for user:", $user.id);
        processedStories.push({
          id: "create",
          isCreateCard: true,
          user_id: $user.id,
          username: userProfile?.username || "You",
          profile_photo_url: userProfile?.profile_photo_url || null,
        });
      }

      // Add all users with their stories to the final array
      uniqueUsers.forEach((user) => {
        processedStories.push(user);
      });

      stories = processedStories;
      console.log("Processed stories:", stories);
    } catch (err) {
      console.error("Error fetching stories:", err);
      stories = [];
    }
  }

  function handleStoryClick(story) {
    if (story.isCreateCard) {
      // Navigate to story creation page
      if ($user) {
        console.log("Navigating to create-story");
        navigate("/create-story");
      } else {
        console.log("User not logged in, navigating to login");
        navigate("/login");
      }
    } else {
      // Navigate to story viewing page - pass either user's first story id or username
      if (story.stories && story.stories.length > 0) {
        // Pass the first unviewed story id, or the first story if all are viewed
        const firstUnviewed = story.stories.find((s) => !s.viewed);
        const storyId = firstUnviewed ? firstUnviewed.id : story.stories[0].id;
        console.log("Navigating to view story:", storyId);
        navigate(`/story/${storyId}`);
      } else {
        // Fallback to username-based navigation
        console.log("Navigating to user stories:", story.username);
        navigate(`/stories/${story.username}`);
      }
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
      {#if $user}
        <div
          class="create-story-button"
          tabindex="0"
          role="button"
          on:click={() => navigate("/create-story")}
          on:keydown={(e) => {
            if (e.key === "Enter" || e.key === "Space") {
              e.preventDefault();
              navigate("/create-story");
            }
          }}
        >
          <div class="create-icon">+</div>
          <span>Create Story</span>
        </div>
      {:else}
        <p>No stories available</p>
      {/if}
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
            {:else if story.profile_photo_url}
              <img
                src={story.profile_photo_url}
                alt={story.username}
                class="story-avatar"
              />
            {:else}
              <div class="story-avatar-placeholder">
                {story.username.charAt(0).toUpperCase()}
              </div>
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

  .story-avatar-placeholder {
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: var(--light-gray);
    border-radius: 50%;
    color: var(--charcoal);
    font-weight: bold;
    font-size: 24px;
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
    display: flex;
    justify-content: center;
  }

  .empty-state p {
    color: var(--gray);
    margin: 0;
  }

  .create-story-button {
    display: flex;
    flex-direction: column;
    align-items: center;
    cursor: pointer;
  }

  .create-story-button .create-icon {
    width: 68px;
    height: 68px;
    border-radius: 50%;
    background: linear-gradient(45deg, #f58a6c, #f26440);
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 32px;
    margin-bottom: 8px;
  }
</style>
