<script>
  import { supabase } from "../supabase.js";
  import { user } from "../stores/user.js";
  import { onMount } from "svelte";

  let profile;
  let loading = true;

  onMount(async () => {
    const { data, error } = await supabase
      .from("users")
      .select("*")
      .eq("id", $user.id)
      .single();
    if (!error) profile = data;
    loading = false;
  });
</script>

<div class="profile">
  {#if loading}
    <p>Loading...</p>
  {:else}
    <h1>{profile.username || "User"}</h1>
    <p>{profile.bio || "No bio yet"}</p>
    <img src="/assets/logo.png" alt="Avatar" class="avatar" />
  {/if}
</div>

<style>
  .profile {
    padding: 20px;
    text-align: center;
  }
  .avatar {
    width: 100px;
    border: 2px solid var(--charcoal);
    border-radius: 50%;
    margin-top: 20px;
  }
</style>
