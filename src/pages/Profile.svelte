<script>
  import { onMount } from "svelte";
  import { supabase } from "../supabase.js";
  import { user } from "../stores.js";

  let profile = null;
  let loading = true;
  let error = null;
  let editing = false;
  let passwordForm = {
    currentPassword: "",
    newPassword: "",
    confirmPassword: "",
  };
  let profilePhotoFile = null;

  onMount(async () => {
    if ($user) {
      await fetchProfile();
    } else {
      error = "Please log in to view your profile";
      loading = false;
    }
  });

  async function fetchProfile() {
    try {
      loading = true;
      const { data, error: fetchError } = await supabase
        .from("profiles")
        .select("*")
        .eq("id", $user.id)
        .single();

      if (fetchError) throw fetchError;
      profile = data || { id: $user.id }; // Default if no profile exists
      error = null;
    } catch (err) {
      error = err.message;
      console.error("Error fetching profile:", err);
    } finally {
      loading = false;
    }
  }

  async function updateProfile() {
    try {
      const updates = {
        id: $user.id,
        first_name: profile.first_name,
        last_name: profile.last_name,
        username: profile.username,
      };

      const { error: updateError } = await supabase
        .from("profiles")
        .upsert(updates, { onConflict: "id" });

      if (updateError) throw updateError;

      editing = false;
      alert("Profile updated successfully");
    } catch (err) {
      alert("Failed to update profile: " + err.message);
    }
  }

  async function changePassword() {
    try {
      if (passwordForm.newPassword !== passwordForm.confirmPassword) {
        throw new Error("New passwords do not match");
      }

      const { error: passwordError } = await supabase.auth.updateUser({
        password: passwordForm.newPassword,
      });

      if (passwordError) throw passwordError;

      alert("Password changed successfully");
      passwordForm = {
        currentPassword: "",
        newPassword: "",
        confirmPassword: "",
      };
    } catch (err) {
      alert("Failed to change password: " + err.message);
    }
  }

  async function uploadProfilePhoto() {
    if (!profilePhotoFile) return;

    try {
      const fileExt = profilePhotoFile.name.split(".").pop();
      const fileName = `${$user.id}.${fileExt}`;
      const { error: uploadError } = await supabase.storage
        .from("profile_photos")
        .upload(fileName, profilePhotoFile, { upsert: true });

      if (uploadError) throw uploadError;

      const { data } = supabase.storage
        .from("profile_photos")
        .getPublicUrl(fileName);

      const publicURL = data.publicUrl;

      const { error: updateError } = await supabase
        .from("profiles")
        .update({ profile_photo_url: publicURL })
        .eq("id", $user.id);

      if (updateError) throw updateError;

      profile.profile_photo_url = publicURL;
      alert("Profile photo updated successfully");
    } catch (err) {
      alert("Failed to upload profile photo: " + err.message);
    }
  }
</script>

<div class="profile-page">
  <div class="sidebar">
    <nav>
      <a href="#personal-details">Personal Details</a>
      <a href="#account-info">Account Info</a>
    </nav>
  </div>
  <div class="content">
    {#if loading}
      <p>Loading...</p>
    {:else if error}
      <p class="error">Error: {error}</p>
    {:else}
      <section id="personal-details">
        <h2>Personal Details</h2>
        {#if editing}
          <form on:submit|preventDefault={updateProfile}>
            <label>
              First Name:
              <input type="text" bind:value={profile.first_name} required />
            </label>
            <label>
              Last Name:
              <input type="text" bind:value={profile.last_name} required />
            </label>
            <label>
              Username:
              <input type="text" bind:value={profile.username} required />
            </label>
            <label>
              Profile Photo:
              <input
                type="file"
                accept="image/*"
                on:change={(e) => (profilePhotoFile = e.target.files[0])}
              />
              <button type="button" on:click={uploadProfilePhoto}
                >Upload Photo</button
              >
            </label>
            <div class="buttons">
              <button type="submit">Save Changes</button>
              <button
                type="button"
                on:click={() => (editing = false)}
                class="cancel-btn">Cancel</button
              >
            </div>
          </form>
        {:else}
          <p>First Name: {profile.first_name || "Not set"}</p>
          <p>Last Name: {profile.last_name || "Not set"}</p>
          <p>Username: @{profile.username || "Not set"}</p>
          {#if profile.profile_photo_url}
            <img
              src={profile.profile_photo_url}
              alt="Profile Photo"
              class="profile-photo"
            />
          {/if}
          <button on:click={() => (editing = true)}>Edit</button>
        {/if}
      </section>

      <section id="account-info">
        <h2>Account Info</h2>
        <p>Email: {$user.email}</p>
        <p>Username: @{profile.username || "Not set"}</p>
        <h3>Change Password</h3>
        <form on:submit|preventDefault={changePassword}>
          <label>
            Current Password:
            <input
              type="password"
              bind:value={passwordForm.currentPassword}
              required
            />
          </label>
          <label>
            New Password:
            <input
              type="password"
              bind:value={passwordForm.newPassword}
              required
            />
          </label>
          <label>
            Confirm New Password:
            <input
              type="password"
              bind:value={passwordForm.confirmPassword}
              required
            />
          </label>
          <button type="submit">Change Password</button>
        </form>
      </section>
    {/if}
  </div>
</div>

<style>
  .profile-page {
    display: flex;
    gap: 2rem;
    padding: 2rem;
  }

  .sidebar {
    width: 200px;
  }

  .sidebar nav {
    display: flex;
    flex-direction: column;
    gap: 1rem;
  }

  .sidebar a {
    text-decoration: none;
    color: #333;
    padding: 0.5rem;
  }

  .sidebar a:hover {
    background-color: #f0f0f0;
  }

  .content {
    flex: 1;
  }

  section {
    margin-bottom: 2rem;
  }

  form {
    display: flex;
    flex-direction: column;
    gap: 1rem;
    max-width: 400px;
  }

  label {
    display: flex;
    flex-direction: column;
    gap: 0.25rem;
  }

  input {
    padding: 0.5rem;
    border: 1px solid #ccc;
    border-radius: 4px;
  }

  .buttons {
    display: flex;
    gap: 1rem;
  }

  button {
    padding: 0.5rem 1rem;
    border: none;
    border-radius: 4px;
    background-color: #007bff;
    color: white;
    cursor: pointer;
  }

  button:hover {
    background-color: #0056b3;
  }

  .cancel-btn {
    background-color: #6c757d;
  }

  .cancel-btn:hover {
    background-color: #ff6347; /* Tomato red on hover */
  }

  .profile-photo {
    max-width: 200px;
    border-radius: 50%;
    margin: 1rem 0;
  }

  .error {
    color: red;
  }
</style>
