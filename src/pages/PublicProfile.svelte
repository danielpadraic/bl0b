<script>
  import { onMount } from "svelte";
  import { supabase } from "../supabase.js";
  import { user } from "../stores.js";
  import { navigate } from "svelte-routing";

  export let username; // Passed from route params

  let profile = null;
  let loading = true;
  let error = null;
  let isFriend = false;
  let isFollowing = false;
  let isBlocked = false;

  onMount(async () => {
    if (!$user) {
      error = "Please log in to view profiles";
      loading = false;
      return;
    }
    await fetchProfile();
    await checkRelationships();
  });

  async function fetchProfile() {
    try {
      const { data, error: fetchError } = await supabase
        .from("profiles")
        .select("*")
        .eq("username", username)
        .single();

      if (fetchError) throw fetchError;
      profile = data;
    } catch (err) {
      error = "Profile not found or access denied";
      console.error("Error fetching profile:", err);
    } finally {
      loading = false;
    }
  }

  async function checkRelationships() {
    if (!profile || !$user) return;

    const { data: friendData } = await supabase
      .from("friends")
      .select("id")
      .eq("user_id", $user.id)
      .eq("friend_id", profile.id);
    isFriend = friendData && friendData.length > 0;

    const { data: followData } = await supabase
      .from("follows")
      .select("id")
      .eq("follower_id", $user.id)
      .eq("following_id", profile.id);
    isFollowing = followData && followData.length > 0;

    const { data: blockData } = await supabase
      .from("blocks")
      .select("id")
      .eq("blocker_id", $user.id)
      .eq("blocked_id", profile.id);
    isBlocked = blockData && blockData.length > 0;
  }

  async function addFriend() {
    try {
      const { error } = await supabase
        .from("friends")
        .insert([{ user_id: $user.id, friend_id: profile.id }]);
      if (error) throw error;
      isFriend = true;
      alert("Friend added!");
    } catch (err) {
      alert("Failed to add friend: " + err.message);
    }
  }

  async function removeFriend() {
    try {
      const { error } = await supabase
        .from("friends")
        .delete()
        .eq("user_id", $user.id)
        .eq("friend_id", profile.id);
      if (error) throw error;
      isFriend = false;
      alert("Friend removed!");
    } catch (err) {
      alert("Failed to remove friend: " + err.message);
    }
  }

  async function followUser() {
    try {
      const { error } = await supabase
        .from("follows")
        .insert([{ follower_id: $user.id, following_id: profile.id }]);
      if (error) throw error;
      isFollowing = true;
      alert("Now following!");
    } catch (err) {
      alert("Failed to follow: " + err.message);
    }
  }

  async function unfollowUser() {
    try {
      const { error } = await supabase
        .from("follows")
        .delete()
        .eq("follower_id", $user.id)
        .eq("following_id", profile.id);
      if (error) throw error;
      isFollowing = false;
      alert("Unfollowed!");
    } catch (err) {
      alert("Failed to unfollow: " + err.message);
    }
  }

  async function blockUser() {
    try {
      const { error } = await supabase
        .from("blocks")
        .insert([{ blocker_id: $user.id, blocked_id: profile.id }]);
      if (error) throw error;
      isBlocked = true;
      alert("User blocked!");
      navigate("/"); // Redirect after blocking
    } catch (err) {
      alert("Failed to block: " + err.message);
    }
  }

  function formatHeight(inches) {
    if (!inches) return "Not set";
    const feet = Math.floor(inches / 12);
    const remainingInches = inches % 12;
    return `${feet}'${remainingInches}"`;
  }
</script>

<div class="public-profile">
  {#if loading}
    <p>Loading...</p>
  {:else if error}
    <p class="error">{error}</p>
  {:else}
    <h1>@{profile.username}</h1>
    {#if profile.profile_photo_url && profile.profile_photo_url_public}
      <img
        src={profile.profile_photo_url}
        alt="Profile"
        class="profile-photo"
      />
    {/if}
    <div class="actions">
      {#if isFriend}
        <button on:click={removeFriend}>Remove Friend</button>
      {:else}
        <button on:click={addFriend}>Add Friend</button>
      {/if}
      {#if isFollowing}
        <button on:click={unfollowUser}>Unfollow</button>
      {:else}
        <button on:click={followUser}>Follow</button>
      {/if}
      {#if !isBlocked}
        <button on:click={blockUser} class="block-btn">Block</button>
      {/if}
    </div>
    <div class="profile-details">
      {#if profile.first_name_public}
        <p>First Name: {profile.first_name}</p>
      {/if}
      {#if profile.last_name_public}
        <p>Last Name: {profile.last_name}</p>
      {/if}
      {#if profile.phone_number_public}
        <p>Phone Number: {profile.phone_number}</p>
      {/if}
      {#if profile.address_public}
        <p>Address: {profile.address}</p>
      {/if}
      {#if profile.participates_in_challenges_public}
        <p>
          Participates in Challenges: {profile.participates_in_challenges
            ? "Yes"
            : "No"}
        </p>
      {/if}
      {#if profile.gender_public}
        <p>Gender: {profile.gender}</p>
      {/if}
      {#if profile.dob_public}
        <p>Date of Birth: {profile.dob}</p>
      {/if}
      {#if profile.height_public}
        <p>Height: {formatHeight(profile.height)}</p>
      {/if}
      {#if profile.weight_public}
        <p>Weight: {profile.weight} lbs</p>
      {/if}
      {#if profile.body_fat_percentage_public}
        <p>Body Fat Percentage: {profile.body_fat_percentage}%</p>
      {/if}
      {#if profile.bmi_public}
        <p>BMI: {profile.bmi}</p>
      {/if}
      {#if profile.bmr_public}
        <p>BMR: {profile.bmr} kcal/day</p>
      {/if}
    </div>
  {/if}
</div>

<style>
  .public-profile {
    padding: 20px;
    max-width: 800px;
    margin: 0 auto;
  }

  h1 {
    font-size: 2rem;
    color: var(--charcoal);
    margin-bottom: 20px;
  }

  .profile-photo {
    max-width: 150px;
    border-radius: 50%;
    margin-bottom: 20px;
  }

  .actions {
    display: flex;
    gap: 10px;
    margin-bottom: 20px;
  }

  button {
    padding: 10px 20px;
    border: none;
    border-radius: 4px;
    background-color: var(--carolina-blue);
    color: var(--white);
    cursor: pointer;
  }

  button:hover {
    background-color: var(--tomato);
  }

  .block-btn {
    background-color: var(--gray);
  }

  .block-btn:hover {
    background-color: var(--tomato-light);
  }

  .profile-details p {
    font-size: 1rem;
    margin: 10px 0;
  }

  .error {
    color: var(--tomato);
    font-size: 1rem;
  }
</style>
