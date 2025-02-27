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
        .select("*")
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
          };
        });
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
    <div class="header-table">
      <table>
        <tr><th>Title</th><td>{challenge.title}</td></tr>
        <tr><th>Type</th><td>{challenge.type}</td></tr>
        <tr
          ><th>Participants</th><td
            >{challenge.participants_current ||
              0}/{challenge.participants_max === 0
              ? "Unlimited"
              : challenge.participants_max}</td
          ></tr
        >
        <tr><th>Cost</th><td>${challenge.buy_in_cost.toFixed(2)}</td></tr>
        <tr><th>Prize</th><td>${challenge.prize_pool.toFixed(2)}</td></tr>
        <tr><th>Scoring</th><td>{challenge.scoring_type}</td></tr>
        <tr
          ><th>Access</th><td>{challenge.is_private ? "Private" : "Public"}</td
          ></tr
        >
      </table>
    </div>

    {#if challenge.cover_media}
      <div class="cover-media">
        {#if challenge.cover_media.match(/\.(jpg|jpeg|png|gif)$/i)}
          <img src={challenge.cover_media} alt="Challenge Cover" />
        {:else if challenge.cover_media.match(/\.(mp4|webm)$/i)}
          <video controls src={challenge.cover_media}></video>
        {/if}
      </div>
    {/if}

    <div class="contestants">
      <h2>Contestants</h2>
      {#if contestants.length > 0}
        <ul>
          {#each contestants as contestant}
            <li>{contestant.username}</li>
          {/each}
        </ul>
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
    padding: 1rem;
    max-width: 800px;
    margin: 0 auto;
    background-color: var(--background);
    color: var(--text);
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  }

  .header-table table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 1rem;
  }

  .header-table th,
  .header-table td {
    padding: 0.5rem;
    border: 1px solid var(--light-gray);
  }

  .header-table th {
    background-color: var(--carolina-blue);
    color: var(--charcoal);
    font-size: 0.9rem;
    width: 30%;
  }

  .header-table td {
    background-color: var(--white);
    color: var(--charcoal);
  }

  .cover-media {
    margin: 1rem 0;
    text-align: center;
  }

  .cover-media img,
  .cover-media video {
    max-width: 100%;
    border-radius: 4px;
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
  }

  .contestants {
    margin-top: 1rem;
  }

  h2 {
    font-size: 1.2rem;
    color: var(--charcoal);
    margin-bottom: 0.5rem;
  }

  ul {
    list-style: none;
    padding: 0;
  }

  li {
    padding: 0.5rem;
    background-color: var(--light-gray);
    margin-bottom: 0.25rem;
    border-radius: 4px;
    font-size: 0.9rem;
    color: var(--charcoal);
  }

  button {
    background-color: var(--tomato);
    color: var(--white);
    border: none;
    padding: 0.5rem 1rem;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.3s;
    margin-top: 1rem;
  }

  button:hover {
    background-color: var(--tomato-light);
  }

  .error {
    color: var(--tomato);
  }
</style>
