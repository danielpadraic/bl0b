<script>
  import { onMount } from "svelte";
  import { supabase } from "../supabase.js";
  import { user } from "../stores.js";
  import { navigate } from "svelte-routing";

  export let challengeId;

  let challenge = null;
  let contestants = [];
  let loading = true;
  let error = null;

  onMount(async () => {
    console.log("ChallengeDetails mounted with challengeId:", challengeId);
    await fetchChallengeDetails();
    if (challenge) {
      await fetchContestants();
    } else {
      console.log("No challenge found, skipping contestants fetch");
    }
    loading = false;
  });

  async function fetchChallengeDetails() {
    try {
      const { data, error: fetchError } = await supabase
        .from("challenges")
        .select("*, profiles!challenges_creator_id_fkey(username)")
        .eq("id", challengeId)
        .single();
      console.log("Fetched challenge data:", data, "Error:", fetchError);
      if (fetchError) throw fetchError;
      challenge = data;
    } catch (err) {
      error = err.message;
      console.error("Fetch challenge error:", err);
    }
  }

  async function fetchContestants() {
    try {
      const { data, error: fetchError } = await supabase
        .from("challenge_participants")
        .select("user_id")
        .eq("challenge_id", challengeId);
      console.log("Fetched participants:", data, "Error:", fetchError);
      if (fetchError) throw fetchError;

      if (data.length > 0) {
        const userIds = data.map((participant) => participant.user_id);
        const { data: profilesData, error: profilesError } = await supabase
          .from("profiles")
          .select("id, username")
          .in("id", userIds);
        console.log("Fetched profiles:", profilesData, "Error:", profilesError);
        if (profilesError) throw profilesError;

        contestants = data.map((participant) => {
          const profile = profilesData.find(
            (p) => p.id === participant.user_id
          );
          return {
            user_id: participant.user_id,
            username: profile ? profile.username : "Unknown",
            position: Math.floor(Math.random() * 100), // Placeholder for real-time position
          };
        });

        // Sort contestants based on challenge status
        const now = new Date();
        const start = challenge.start_datetime
          ? new Date(challenge.start_datetime)
          : null;
        if (start && now >= start) {
          // After start: sort by position, then username for ties
          contestants.sort((a, b) => {
            if (a.position === b.position) {
              return a.username.localeCompare(b.username);
            }
            return b.position - a.position; // Higher position (score) first
          });
        } else {
          // Before start: alphabetical by username
          contestants.sort((a, b) => a.username.localeCompare(b.username));
        }
      }
    } catch (err) {
      error = err.message;
      console.error("Fetch contestants error:", err);
    }
  }

  function joinChallenge() {
    if (!$user) {
      navigate("/login");
      return;
    }
    supabase
      .from("challenge_participants")
      .insert([{ challenge_id: challengeId, user_id: $user.id }])
      .then(() => fetchContestants());
  }
</script>

<div class="challenge-details">
  {#if loading}
    <p>Loading...</p>
  {:else if error}
    <p class="error">Error: {error}</p>
  {:else if challenge}
    <div class="header-section">
      <h1>Challenge Details</h1>
      <div class="header-table">
        <table>
          <tr>
            <th>Title</th><td>{challenge.title}</td>
            <th>Type</th><td>{challenge.type}</td>
          </tr>
          <tr>
            <th>Participants</th><td
              >{challenge.participants_current ||
                0}/{challenge.participants_max === 0
                ? "Unlimited"
                : challenge.participants_max}</td
            >
            <th>Cost</th><td>${challenge.buy_in_cost.toFixed(2)}</td>
          </tr>
          <tr>
            <th>Prize</th><td>${challenge.prize_pool.toFixed(2)}</td>
            <th>Scoring</th><td>{challenge.scoring_type}</td>
          </tr>
          <tr>
            <th>Access</th><td>{challenge.is_private ? "Private" : "Public"}</td
            >
            <th>Creator</th><td>{challenge.profiles.username || "Unknown"}</td>
          </tr>
          <tr>
            <th>Start</th><td
              >{challenge.start_datetime
                ? new Date(challenge.start_datetime).toLocaleString()
                : "Not set"}</td
            >
            <th>End</th><td
              >{challenge.end_datetime
                ? new Date(challenge.end_datetime).toLocaleString()
                : "Not set"}</td
            >
          </tr>
        </table>
      </div>
    </div>

    {#if challenge.cover_media}
      <div class="cover-media">
        {#if challenge.cover_media.match(/\.(jpg|jpeg|png|gif)$/i)}
          <img src={challenge.cover_media} alt="Challenge Cover" />
        {:else if challenge.cover_media.match(/\.(mp4|webm)$/i)}
          <video controls src={challenge.cover_media}>
            <track kind="captions" label="No captions available" />
          </video>
        {/if}
      </div>
    {/if}

    <div class="contestants">
      <h2>Contestants</h2>
      {#if contestants.length > 0}
        <table class="contestants-table">
          <thead>
            <tr>
              <th>Rank</th>
              <th>Username</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            {#each contestants as contestant, index}
              <tr>
                <td>{index + 1}</td>
                <td>{contestant.username}</td>
                <td>Active</td>
                <!-- Placeholder status -->
              </tr>
            {/each}
          </tbody>
        </table>
      {:else}
        <p>No contestants yet.</p>
      {/if}
      {#if !$user || !contestants.some((c) => c.user_id === $user.id)}
        <button on:click={joinChallenge}>Join Challenge</button>
      {/if}
    </div>
  {:else}
    <p>Challenge not found.</p>
  {/if}
</div>

<style>
  .challenge-details {
    padding: 2rem;
    max-width: 900px;
    margin: 0 auto;
    background: linear-gradient(145deg, var(--background), var(--light-gray));
    color: var(--text);
    border-radius: 12px;
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
  }

  .header-section {
    text-align: center;
    margin-bottom: 2rem;
  }

  h1 {
    font-size: 2rem;
    color: var(--charcoal);
    text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1);
    margin-bottom: 1.5rem;
  }

  .header-table table {
    width: 100%;
    max-width: 700px;
    margin: 0 auto;
    border-collapse: separate;
    border-spacing: 0;
    background: var(--white);
    border-radius: 8px;
    box-shadow:
      0 4px 12px rgba(0, 0, 0, 0.15),
      inset 0 1px 2px rgba(255, 255, 255, 0.5);
    transform: translateZ(0); /* For 3D effect */
  }

  .header-table th,
  .header-table td {
    padding: 0.75rem 1rem;
    border: 1px solid var(--light-gray);
    font-size: 0.95rem;
    transition: all 0.3s ease;
  }

  .header-table th {
    background: linear-gradient(to bottom, var(--carolina-blue), #87ceeb);
    color: var(--charcoal);
    font-weight: bold;
    text-shadow: 0 1px 1px rgba(255, 255, 255, 0.8);
    width: 25%;
    border-top-left-radius: 8px;
    border-top-right-radius: 8px;
  }

  .header-table td {
    background-color: var(--white);
    color: var(--charcoal);
    width: 25%;
    box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.05);
  }

  .header-table tr:hover td {
    background-color: var(--light-gray);
    transform: translateY(-2px);
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }

  .cover-media {
    margin: 2rem 0;
    text-align: center;
  }

  .cover-media img,
  .cover-media video {
    max-width: 100%;
    border-radius: 8px;
    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.2);
    transition: transform 0.3s ease;
  }

  .cover-media img:hover,
  .cover-media video:hover {
    transform: scale(1.02);
  }

  .contestants {
    margin-top: 2rem;
  }

  h2 {
    font-size: 1.5rem;
    color: var(--charcoal);
    text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1);
    margin-bottom: 1rem;
  }

  .contestants-table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0;
    background: var(--white);
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  }

  .contestants-table th,
  .contestants-table td {
    padding: 0.75rem;
    border: 1px solid var(--light-gray);
    text-align: left;
    font-size: 0.9rem;
  }

  .contestants-table th {
    background: linear-gradient(to bottom, var(--tomato), var(--tomato-light));
    color: var(--white);
    font-weight: bold;
    text-shadow: 0 1px 1px rgba(0, 0, 0, 0.2);
  }

  .contestants-table td {
    background-color: var(--white);
    color: var(--charcoal);
    transition: background-color 0.3s ease;
  }

  .contestants-table tr:hover td {
    background-color: var(--light-gray);
    box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.05);
  }

  button {
    background-color: var(--tomato);
    color: var(--white);
    border: none;
    padding: 0.75rem 1.5rem;
    border-radius: 6px;
    cursor: pointer;
    font-size: 1rem;
    transition: all 0.3s ease;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    margin-top: 1.5rem;
  }

  button:hover {
    background-color: var(--tomato-light);
    transform: translateY(-2px);
    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.25);
  }

  .error {
    color: var(--tomato);
    font-size: 1.1rem;
    text-align: center;
  }
</style>
