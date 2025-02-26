<script>
  import { supabase } from "../supabase.js";
  import { user } from "../stores/user.js";
  import { navigate } from "svelte-routing";
  import { uploadFile } from "../utils/upload.js";

  let name = "";
  let description = "";
  let type = "public";
  let metric = "";
  let scoringType = "sum";
  let timePeriod = "";
  let fileInput;

  async function createChallenge() {
    let mediaUrl = "";
    if (fileInput.files.length > 0) {
      const file = fileInput.files[0];
      const { Key } = await uploadFile(
        file,
        "challenge-media",
        `${Date.now()}-${file.name}`
      );
      mediaUrl = supabase.storage.from("challenge-media").getPublicUrl(Key)
        .data.publicUrl;
    }
    const { error } = await supabase.from("challenges").insert([
      {
        name,
        description,
        type,
        metric,
        scoring_type: scoringType,
        time_period: timePeriod,
        creator: supabase.auth.user().id,
        media_url: mediaUrl,
      },
    ]);
    if (!error) goto("/");
  }
</script>

<div class="challenge-creation">
  <h1>Create Challenge</h1>
  <form on:submit|preventDefault={createChallenge}>
    <input
      type="text"
      bind:value={name}
      placeholder="Challenge Name"
      required
    />
    <textarea bind:value={description} placeholder="Description" required
    ></textarea>
    <select bind:value={type}>
      <option value="public">Public</option>
      <option value="private">Private</option>
    </select>
    <input
      type="text"
      bind:value={metric}
      placeholder="Metric (e.g., miles)"
      required
    />
    <select bind:value={scoringType}>
      <option value="sum">Sum</option>
      <option value="average">Average</option>
    </select>
    <input
      type="text"
      bind:value={timePeriod}
      placeholder="Time Period (e.g., 1 week)"
      required
    />
    <input type="file" bind:this={fileInput} />
    <button type="submit">Create</button>
  </form>
</div>

<style>
  .challenge-creation {
    padding: 20px;
  }
  form {
    display: flex;
    flex-direction: column;
    gap: 10px;
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
