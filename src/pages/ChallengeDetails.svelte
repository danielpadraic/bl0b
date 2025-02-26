<script>
  import { supabase } from "../supabase.js";
  import { onMount } from "svelte";
  import { uploadFile } from "../utils/upload.js";

  export let id;
  let challenge;
  let loading = true;
  let isParticipant = false;
  let logValue = "";
  let logFile;

  onMount(async () => {
    const { data, error } = await supabase
      .from("challenges")
      .select("*")
      .eq("id", id)
      .single();
    if (!error) {
      challenge = data;
      const { data: participants } = await supabase
        .from("challenge_participants")
        .select("*")
        .eq("challenge_id", id)
        .eq("user_id", supabase.auth.user().id);
      isParticipant = participants.length > 0;
    }
    loading = false;
  });

  async function joinChallenge() {
    const { error } = await supabase
      .from("challenge_participants")
      .insert([{ challenge_id: id, user_id: supabase.auth.user().id }]);
    if (!error) isParticipant = true;
  }

  async function logProgress() {
    let proofUrl = "";
    if (logFile) {
      const { Key } = await uploadFile(
        logFile,
        "proof-media",
        `${Date.now()}-${logFile.name}`
      );
      proofUrl = supabase.storage.from("proof-media").getPublicUrl(Key)
        .data.publicUrl;
    }
    const { error } = await supabase.from("user_challenge_logs").insert([
      {
        challenge_id: id,
        user_id: supabase.auth.user().id,
        metric_value: logValue,
        proof_url: proofUrl,
      },
    ]);
    if (!error) {
      logValue = "";
      logFile = null;
    }
  }
</script>

<div class="challenge-details">
  {#if loading}
    <p>Loading...</p>
  {:else}
    <h1>{challenge.name}</h1>
    <p>{challenge.description}</p>
    {#if challenge.media_url}
      <video src={challenge.media_url} controls width="100%">
        <track
          kind="captions"
          label="English"
          srclang="en"
          src="/captions.vtt"
          default
        />
      </video>
    {/if}
    {#if isParticipant}
      <form on:submit|preventDefault={logProgress}>
        <input
          type="number"
          bind:value={logValue}
          placeholder="Enter progress"
          required
        />
        <input type="file" on:change={(e) => (logFile = e.target.files[0])} />
        <button type="submit">Log Progress</button>
      </form>
    {:else}
      <button on:click={joinChallenge}>Join Challenge</button>
    {/if}
  {/if}
</div>

<style>
  .challenge-details {
    padding: 20px;
  }
  form {
    display: flex;
    flex-direction: column;
    gap: 10px;
    margin-top: 20px;
    border: 1px solid var(--charcoal);
    padding: 10px;
  }
  button {
    background-color: var(--tomato);
    color: white;
    border: none;
    padding: 10px;
    cursor: pointer;
  }
</style>
