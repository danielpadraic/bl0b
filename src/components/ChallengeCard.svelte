<script>
  export let challenge = {};
  export let compact = false;

  function formatCurrency(value) {
    if (!value) return "$0";
    return `$${value.toFixed(2)}`;
  }

  function formatDate(dateString) {
    if (!dateString) return "TBD";
    const date = new Date(dateString);
    const now = new Date();
    const diffTime = date - now;
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    if (diffDays === 0) return "Today";
    else if (diffDays === 1) return "Tomorrow";
    else if (diffDays > 1 && diffDays < 7) return `In ${diffDays} days`;
    return date.toLocaleDateString("en-US", { month: "short", day: "numeric" });
  }

  function getStatusBadge(status) {
    switch (status) {
      case "active":
        return { text: "Active", color: "#4CAF50" };
      case "upcoming":
        return { text: "Upcoming", color: "#2196F3" };
      case "completed":
        return { text: "Completed", color: "#9E9E9E" };
      default:
        return { text: "Unknown", color: "#9E9E9E" };
    }
  }

  function getParticipantsText(current, max) {
    if (max === 0 || max === null) return `${current} participants`;
    return `${current}/${max} participants`;
  }

  function handleClick(event) {
    event.currentTarget.dispatchEvent(
      new CustomEvent("click", { bubbles: true })
    );
  }

  const badge = getStatusBadge(challenge.status);
  const participantsText = getParticipantsText(
    challenge.participants_current || 0,
    challenge.participants_max
  );
  const startDate = formatDate(challenge.start_datetime);
  const fallbackImage = "https://via.placeholder.com/300?text=No+Image";
</script>

<div
  class="challenge-card {compact ? 'compact' : ''}"
  tabindex="0"
  role="button"
  on:click={handleClick}
  on:keydown={(e) => {
    if (e.key === "Enter" || e.key === "Space") {
      e.preventDefault();
      handleClick(e);
    }
  }}
>
  <div class="card-media">
    <img
      src={challenge.cover_media || fallbackImage}
      alt={challenge.title}
      class="cover-image"
    />
    <div class="badge" style="background-color: {badge.color}">
      {badge.text}
    </div>
    {#if challenge.isJoined}
      <div class="joined-badge">Joined</div>
    {/if}
  </div>

  <div class="card-content">
    <h3 class="card-title">{challenge.title}</h3>

    <div class="card-creator">
      {#if challenge.creatorPhoto}
        <img
          src={challenge.creatorPhoto}
          alt="Creator"
          class="creator-avatar"
        />
      {:else}
        <div class="creator-avatar-placeholder"></div>
      {/if}
      <span class="creator-name">@{challenge.creatorUsername}</span>
    </div>

    <div class="card-details">
      <div class="detail-item">
        <span class="detail-label">Type:</span>
        <span class="detail-value">{challenge.type}</span>
      </div>

      <div class="detail-item">
        <span class="detail-label">Prize:</span>
        <span class="detail-value">{formatCurrency(challenge.prize_pool)}</span>
      </div>

      <div class="detail-item">
        <span class="detail-label">Buy-in:</span>
        <span class="detail-value">{formatCurrency(challenge.buy_in_cost)}</span
        >
      </div>

      <div class="detail-item">
        <span class="detail-label"
          >{challenge.status === "upcoming" ? "Starts:" : "Started:"}</span
        >
        <span class="detail-value">{startDate}</span>
      </div>

      <div class="detail-item">
        <span class="detail-label">Participants:</span>
        <span class="detail-value">{participantsText}</span>
      </div>
    </div>
  </div>
</div>

<style>
  /* Styles remain unchanged */
  .challenge-card {
    background-color: white;
    border-radius: 16px;
    overflow: hidden;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    transition:
      transform 0.2s ease,
      box-shadow 0.2s ease;
    cursor: pointer;
    display: flex;
    flex-direction: column;
    height: 100%;
  }

  .challenge-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  }

  .card-media {
    position: relative;
    padding-top: 56.25%; /* 16:9 aspect ratio */
    background-color: var(--light-gray);
  }

  .cover-image {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  .badge {
    position: absolute;
    top: 10px;
    right: 10px;
    padding: 4px 8px;
    border-radius: 12px;
    font-size: 12px;
    font-weight: 500;
    color: white;
  }

  .joined-badge {
    position: absolute;
    top: 10px;
    left: 10px;
    padding: 4px 8px;
    border-radius: 12px;
    font-size: 12px;
    font-weight: 500;
    background-color: var(--tomato);
    color: white;
  }

  .card-content {
    padding: 12px;
    flex-grow: 1;
    display: flex;
    flex-direction: column;
  }

  .card-title {
    margin: 0 0 8px 0;
    font-size: 16px;
    font-weight: 600;
    color: var(--charcoal);
    display: -webkit-box;
    display: box;
    -webkit-line-clamp: 2;
    line-clamp: 2;
    -webkit-box-orient: vertical;
    box-orient: vertical;
    overflow: hidden;
    text-overflow: ellipsis;
    line-height: 1.3;
  }

  .card-creator {
    display: flex;
    align-items: center;
    margin-bottom: 10px;
  }

  .creator-avatar {
    width: 20px;
    height: 20px;
    border-radius: 50%;
    margin-right: 6px;
    object-fit: cover;
  }

  .creator-avatar-placeholder {
    width: 20px;
    height: 20px;
    border-radius: 50%;
    margin-right: 6px;
    background-color: var(--light-gray);
  }

  .creator-name {
    font-size: 12px;
    color: var(--charcoal);
    opacity: 0.8;
  }

  .card-details {
    font-size: 12px;
    color: var(--charcoal);
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 6px 12px;
  }

  .detail-item {
    display: flex;
    align-items: baseline;
    justify-content: space-between;
  }

  .detail-label {
    color: var(--gray);
    font-weight: 500;
    margin-right: 4px;
  }

  .detail-value {
    color: var(--charcoal);
    font-weight: 500;
  }

  .challenge-card.compact .card-media {
    padding-top: 50%;
  }

  .challenge-card.compact .card-title {
    font-size: 14px;
    -webkit-line-clamp: 1;
    line-clamp: 1;
  }

  .challenge-card.compact .card-content {
    padding: 8px;
  }

  .challenge-card.compact .card-details {
    font-size: 11px;
    grid-template-columns: 1fr;
    gap: 4px;
  }

  .challenge-card.compact .card-creator {
    margin-bottom: 6px;
  }

  .challenge-card.compact .detail-item {
    justify-content: flex-start;
  }

  .challenge-card.compact .detail-label {
    min-width: 55px;
  }
</style>
