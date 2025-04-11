<script>
  import { onMount } from "svelte";
  import { navigate } from "svelte-routing";
  import { user } from "../stores.js";
  import { supabase } from "../supabase.js";
  import LoadingSpinner from "../components/LoadingSpinner.svelte";
  import BottomNav from "../components/BottomNav.svelte";

  let notifications = [];
  let loading = true;
  let error = null;
  let hasMore = false;
  let loadingMore = false;
  let notificationCount = 0;
  let page = 0;
  const PAGE_SIZE = 20;

  onMount(async () => {
    if (!$user) {
      navigate("/login");
      return;
    }

    await fetchNotifications();
  });

  async function fetchNotifications(loadMore = false) {
    if (loadMore) {
      if (loadingMore || !hasMore) return;
      loadingMore = true;
      page += 1;
    } else {
      loading = true;
      page = 0;
      notifications = [];
    }

    try {
      const {
        data,
        error: fetchError,
        count,
      } = await supabase
        .from("notifications")
        .select("*", { count: "exact" })
        .eq("user_id", $user.id)
        .order("created_at", { ascending: false })
        .range(page * PAGE_SIZE, (page + 1) * PAGE_SIZE - 1);

      if (fetchError) throw fetchError;

      // Process notifications
      const processedNotifications = await Promise.all(
        data.map(async (notification) => {
          let userData = null;

          // If notification involves another user, get their info
          if (notification.sender_id) {
            const { data: profile } = await supabase
              .from("profiles")
              .select("username, profile_photo_url")
              .eq("id", notification.sender_id)
              .single();

            userData = profile;
          }

          // Get related challenge info if there is a challenge_id
          let challengeData = null;
          if (notification.challenge_id) {
            const { data: challenge } = await supabase
              .from("challenges")
              .select("title")
              .eq("id", notification.challenge_id)
              .single();

            challengeData = challenge;
          }

          return {
            ...notification,
            formattedTime: formatTime(notification.created_at),
            sender: userData,
            challenge: challengeData,
          };
        })
      );

      if (loadMore) {
        notifications = [...notifications, ...processedNotifications];
      } else {
        notifications = processedNotifications;
      }

      hasMore = (page + 1) * PAGE_SIZE < count;

      // If this is the initial load, mark notifications as read
      if (!loadMore) {
        markAllAsRead();
      }
    } catch (err) {
      console.error("Error fetching notifications:", err);
      error = err.message;
    } finally {
      loading = false;
      loadingMore = false;
    }
  }

  async function markAllAsRead() {
    try {
      const { error: updateError } = await supabase
        .from("notifications")
        .update({ read: true })
        .eq("user_id", $user.id)
        .eq("read", false);

      if (updateError) throw updateError;

      notificationCount = 0;
    } catch (err) {
      console.error("Error marking notifications as read:", err);
    }
  }

  function formatTime(timestamp) {
    const date = new Date(timestamp);
    const now = new Date();
    const diffTime = Math.abs(now - date);
    const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24));

    if (diffDays < 1) {
      // Today - show time
      return date.toLocaleTimeString(undefined, {
        hour: "2-digit",
        minute: "2-digit",
      });
    } else if (diffDays === 1) {
      // Yesterday
      return "Yesterday";
    } else if (diffDays < 7) {
      // Within last week
      return date.toLocaleDateString(undefined, { weekday: "long" });
    } else {
      // Older
      return date.toLocaleDateString(undefined, {
        month: "short",
        day: "numeric",
        year: date.getFullYear() !== now.getFullYear() ? "numeric" : undefined,
      });
    }
  }

  function getNotificationIcon(type) {
    switch (type) {
      case "challenge_invite":
        return "🏆";
      case "friend_request":
        return "👋";
      case "task_completed":
        return "✅";
      case "comment":
        return "💬";
      case "like":
        return "👍";
      case "achievement":
        return "🎖️";
      case "system":
        return "🔔";
      default:
        return "📣";
    }
  }

  function getNotificationTitle(notification) {
    const { type, sender } = notification;

    switch (type) {
      case "challenge_invite":
        return sender
          ? `${sender.username} invited you to a challenge`
          : "Challenge invitation";
      case "friend_request":
        return sender
          ? `${sender.username} sent you a friend request`
          : "New friend request";
      case "task_completed":
        return "Task completed successfully";
      case "comment":
        return sender
          ? `${sender.username} commented on your post`
          : "New comment";
      case "like":
        return sender ? `${sender.username} liked your post` : "New like";
      case "achievement":
        return "You earned an achievement";
      case "system":
        return "System notification";
      default:
        return "New notification";
    }
  }

  function handleNotificationClick(notification) {
    // Navigate based on notification type and data
    switch (notification.type) {
      case "challenge_invite":
      case "task_completed":
        if (notification.challenge_id) {
          navigate(`/challenge/${notification.challenge_id}`);
        }
        break;
      case "friend_request":
        if (notification.sender_id) {
          navigate(
            `/profile/${notification.sender?.username || notification.sender_id}`
          );
        }
        break;
      case "comment":
      case "like":
        if (notification.post_id) {
          navigate(`/post/${notification.post_id}`);
        }
        break;
      case "achievement":
        navigate("/achievements");
        break;
      default:
        // Do nothing for system notifications or if no action needed
        break;
    }
  }

  function handleScroll(e) {
    const bottom =
      e.target.scrollHeight - e.target.scrollTop - e.target.clientHeight < 50;
    if (bottom && hasMore && !loadingMore) {
      fetchNotifications(true);
    }
  }
</script>

<div class="notifications-page" on:scroll={handleScroll}>
  <div class="page-header">
    <h1>Notifications</h1>

    {#if notifications.length > 0}
      <button class="refresh-button" on:click={() => fetchNotifications()}>
        <span class="refresh-icon">↻</span>
      </button>
    {/if}
  </div>

  <div class="notifications-content">
    {#if loading}
      <div class="loading-container">
        <LoadingSpinner />
      </div>
    {:else if error}
      <div class="error-container">
        <p class="error-message">{error}</p>
        <button class="retry-button" on:click={() => fetchNotifications()}>
          Try Again
        </button>
      </div>
    {:else if notifications.length === 0}
      <div class="empty-state">
        <div class="empty-icon">🔔</div>
        <h2>No Notifications</h2>
        <p>You're all caught up! New notifications will appear here.</p>
      </div>
    {:else}
      <ul class="notifications-list">
        {#each notifications as notification}
          <li class="notification-item" class:unread={!notification.read}>
            <button
              class="notification-button"
              on:click={() => handleNotificationClick(notification)}
              on:keydown={(e) => {
                if (e.key === "Enter" || e.key === "Space") {
                  e.preventDefault();
                  handleNotificationClick(notification);
                }
              }}
            >
              <div class="notification-icon">
                {#if notification.sender && notification.sender.profile_photo_url}
                  <img
                    src={notification.sender.profile_photo_url}
                    alt={notification.sender.username}
                    class="sender-avatar"
                  />
                {:else}
                  <div class="icon-container">
                    {getNotificationIcon(notification.type)}
                  </div>
                {/if}
              </div>

              <div class="notification-content">
                <div class="notification-header">
                  <div class="notification-title">
                    {getNotificationTitle(notification)}
                  </div>
                  <div class="notification-time">
                    {notification.formattedTime}
                  </div>
                </div>

                <div class="notification-body">
                  {notification.message}
                  {#if notification.challenge && notification.challenge.title}
                    <span class="notification-challenge">
                      in "{notification.challenge.title}"
                    </span>
                  {/if}
                </div>

                {#if notification.action_text}
                  <span class="notification-action"
                    >{notification.action_text}</span
                  >
                {/if}
              </div>

              {#if !notification.read}
                <div class="unread-indicator"></div>
              {/if}
            </button>
          </li>
        {/each}
      </ul>

      {#if loadingMore}
        <div class="loading-more">
          <LoadingSpinner size="small" />
          <span>Loading more...</span>
        </div>
      {/if}
    {/if}
  </div>

  <BottomNav activeTab="notifications" notificationCount={0} />
</div>

<style>
  .notifications-page {
    padding-top: 60px; /* For fixed header */
    padding-bottom: 60px; /* For bottom nav */
    min-height: 100vh;
    background-color: var(--background);
    overflow-y: auto;
    max-height: 100vh;
  }

  .page-header {
    padding: 16px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    position: sticky;
    top: 60px;
    background-color: var(--background);
    z-index: 10;
    border-bottom: 1px solid var(--border-color);
  }

  .page-header h1 {
    margin: 0;
    font-size: 1.5rem;
    color: var(--text);
  }

  .refresh-button {
    background: none;
    border: none;
    color: var(--tomato);
    width: 40px;
    height: 40px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: background-color 0.2s;
  }

  .refresh-button:hover {
    background-color: rgba(242, 100, 64, 0.1);
  }

  .refresh-icon {
    font-size: 1.5rem;
  }

  .notifications-content {
    padding: 0 16px 16px;
  }

  .loading-container,
  .error-container,
  .empty-state {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    min-height: 60vh;
    text-align: center;
    padding: 20px;
  }

  .error-message {
    color: var(--error);
    margin-bottom: 16px;
  }

  .retry-button {
    background-color: var(--tomato);
    color: white;
    border: none;
    border-radius: 8px;
    padding: 8px 16px;
    font-weight: 500;
    cursor: pointer;
  }

  .empty-icon {
    font-size: 48px;
    margin-bottom: 16px;
  }

  .empty-state h2 {
    margin: 0 0 8px;
    color: var(--text);
  }

  .empty-state p {
    color: var(--text-secondary);
    margin: 0;
  }

  .notifications-list {
    list-style: none;
    padding: 0;
    margin: 0;
  }

  .notification-item {
    display: flex;
    padding: 16px;
    border-bottom: 1px solid var(--light-gray);
    cursor: pointer;
    transition: background-color 0.2s;
    position: relative;
  }

  .notification-item:hover {
    background-color: rgba(0, 0, 0, 0.02);
  }

  .notification-item.unread {
    background-color: rgba(242, 100, 64, 0.05);
  }

  .notification-button {
    width: 100%;
    text-align: left;
    background: none;
    border: none;
    padding: 16px;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 16px;
  }

  .notification-button:hover {
    background-color: rgba(0, 0, 0, 0.02);
  }

  .notification-item.unread .notification-button {
    background-color: rgba(242, 100, 64, 0.05);
  }

  .notification-icon {
    flex-shrink: 0;
    margin-right: 16px;
  }

  .sender-avatar,
  .icon-container {
    width: 48px;
    height: 48px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .sender-avatar {
    object-fit: cover;
  }

  .icon-container {
    background-color: var(--light-gray);
    font-size: 24px;
  }

  .notification-content {
    flex: 1;
    min-width: 0; /* For text truncation to work */
  }

  .notification-header {
    display: flex;
    justify-content: space-between;
    margin-bottom: 4px;
  }

  .notification-title {
    font-weight: 600;
    color: var(--text);
    font-size: 16px;
  }

  .notification-time {
    color: var(--text-secondary);
    font-size: 12px;
    margin-left: 8px;
    white-space: nowrap;
  }

  .notification-body {
    color: var(--text-secondary);
    font-size: 14px;
    margin-bottom: 8px;
  }

  .notification-challenge {
    color: var(--tomato);
    font-weight: 500;
  }

  .notification-action {
    background-color: var(--carolina-blue);
    color: white;
    border: none;
    border-radius: 4px;
    padding: 6px 12px;
    font-size: 12px;
    font-weight: 500;
    cursor: pointer;
    margin-top: 8px;
  }

  .unread-indicator {
    position: absolute;
    top: 50%;
    right: 16px;
    transform: translateY(-50%);
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background-color: var(--tomato);
  }

  .loading-more {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 16px;
    font-size: 14px;
    color: var(--text-secondary);
    gap: 8px;
  }
</style>
