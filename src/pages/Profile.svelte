<script>
  import { onMount } from "svelte";
  import { supabase } from "../supabase.js";
  import { user } from "../stores.js";

  let profile = null;
  let loading = true;
  let error = null;
  let editingPersonal = false;
  let editingAccount = false;
  let passwordForm = {
    currentPassword: "",
    newPassword: "",
    confirmPassword: "",
  };
  let profilePhotoFile = null;
  let hasMounted = false;

  onMount(() => {
    if (hasMounted) return;
    hasMounted = true;
    console.log("Profile component mounted");
    if ($user) {
      console.log("User ID:", $user.id);
      fetchProfile();
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
        .select("*") // Updated to fetch all fields including visibility toggles
        .eq("id", $user.id)
        .maybeSingle();

      console.log("Fetch result:", { data, fetchError });

      if (fetchError) throw fetchError;

      if (data) {
        profile = data;
      } else {
        profile = {
          id: $user.id,
          first_name: "",
          last_name: "",
          username: "",
          phone_number: "",
          phone_number_raw: "",
          address: "",
          participates_in_challenges: false,
          gender: "",
          dob: "",
          height: 0,
          weight: 0,
          body_fat_percentage: 0,
          profile_photo_url: "",
          bmi: null,
          bmr: null,
          first_name_public: false,
          last_name_public: false,
          username_public: true,
          phone_number_public: false,
          address_public: false,
          participates_in_challenges_public: false,
          gender_public: false,
          dob_public: false,
          height_public: false,
          weight_public: false,
          body_fat_percentage_public: false,
          profile_photo_url_public: true,
          bmi_public: false,
          bmr_public: false,
        };
        await supabase.from("profiles").insert([profile]);
        console.log("Created default profile for user:", $user.id);
      }
      error = null;
    } catch (err) {
      error = err.message;
      console.error("Error fetching profile:", err);
    } finally {
      loading = false;
    }
  }

  function formatHeight(inches) {
    if (!inches) return "Not set";
    const feet = Math.floor(inches / 12);
    const remainingInches = inches % 12;
    return `${feet}'${remainingInches}"`;
  }

  function calculateBMI(height, weight) {
    if (!height || !weight) return null;
    return (weight / (height * height)) * 703;
  }

  function calculateBMR(height, weight, gender, dob) {
    if (!height || !weight || !gender || !dob) return null;
    const weightKg = weight * 0.453592;
    const heightCm = height * 2.54;
    const age = new Date().getFullYear() - new Date(dob).getFullYear();
    if (gender === "Male") {
      return 10 * weightKg + 6.25 * heightCm - 5 * age + 5;
    } else if (gender === "Female") {
      return 10 * weightKg + 6.25 * heightCm - 5 * age - 161;
    }
    return null;
  }

  async function updateProfile() {
    try {
      profile.bmi = calculateBMI(profile.height, profile.weight)?.toFixed(1);
      profile.bmr = calculateBMR(
        profile.height,
        profile.weight,
        profile.gender,
        profile.dob
      )?.toFixed(0);

      const updates = { ...profile, id: $user.id };

      const { error: updateError } = await supabase
        .from("profiles")
        .upsert(updates, { onConflict: "id" });

      if (updateError) throw updateError;

      editingPersonal = false;
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
      editingAccount = false;
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
      <section id="personal-details" class="container">
        <h2>Personal Details</h2>
        {#if editingPersonal}
          <form on:submit|preventDefault={updateProfile}>
            <div class="field-group">
              <label>
                First Name:
                <input type="text" bind:value={profile.first_name} required />
                <label>
                  Public: <input
                    type="checkbox"
                    bind:checked={profile.first_name_public}
                  />
                </label>
              </label>
              <label>
                Last Name:
                <input type="text" bind:value={profile.last_name} required />
                <label>
                  Public: <input
                    type="checkbox"
                    bind:checked={profile.last_name_public}
                  />
                </label>
              </label>
            </div>
            <div class="field-group">
              <label>
                Username:
                <input type="text" bind:value={profile.username} required />
                <label>
                  Public: <input
                    type="checkbox"
                    bind:checked={profile.username_public}
                  />
                </label>
              </label>
              <label>
                Phone Number:
                <input type="text" bind:value={profile.phone_number} />
                <label>
                  Public: <input
                    type="checkbox"
                    bind:checked={profile.phone_number_public}
                  />
                </label>
              </label>
            </div>
            <div class="field-group">
              <label>
                Address:
                <input type="text" bind:value={profile.address} />
                <label>
                  Public: <input
                    type="checkbox"
                    bind:checked={profile.address_public}
                  />
                </label>
              </label>
              <label>
                Participates in Challenges:
                <input
                  type="checkbox"
                  bind:checked={profile.participates_in_challenges}
                />
                <label>
                  Public: <input
                    type="checkbox"
                    bind:checked={profile.participates_in_challenges_public}
                  />
                </label>
              </label>
            </div>
            <div class="field-group">
              <label>
                Gender:
                <div class="radio-group">
                  <label
                    ><input
                      type="radio"
                      bind:group={profile.gender}
                      value="Male"
                    /> Male</label
                  >
                  <label
                    ><input
                      type="radio"
                      bind:group={profile.gender}
                      value="Female"
                    /> Female</label
                  >
                </div>
                <label>
                  Public: <input
                    type="checkbox"
                    bind:checked={profile.gender_public}
                  />
                </label>
              </label>
              <label>
                Date of Birth:
                <input type="date" bind:value={profile.dob} />
                <label>
                  Public: <input
                    type="checkbox"
                    bind:checked={profile.dob_public}
                  />
                </label>
              </label>
            </div>
            <div class="field-group">
              <label>
                Height (in inches):
                <input
                  type="number"
                  bind:value={profile.height}
                  min="0"
                  step="1"
                />
                <label>
                  Public: <input
                    type="checkbox"
                    bind:checked={profile.height_public}
                  />
                </label>
              </label>
              <label>
                Weight (in lbs):
                <input
                  type="number"
                  bind:value={profile.weight}
                  min="0"
                  step="1"
                />
                <label>
                  Public: <input
                    type="checkbox"
                    bind:checked={profile.weight_public}
                  />
                </label>
              </label>
            </div>
            <div class="field-group">
              <label>
                Body Fat Percentage:
                <input
                  type="number"
                  bind:value={profile.body_fat_percentage}
                  min="0"
                  max="100"
                />
                <label>
                  Public: <input
                    type="checkbox"
                    bind:checked={profile.body_fat_percentage_public}
                  />
                </label>
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
                <label>
                  Public: <input
                    type="checkbox"
                    bind:checked={profile.profile_photo_url_public}
                  />
                </label>
              </label>
            </div>
            <div class="buttons">
              <button type="submit">Save Changes</button>
              <button
                type="button"
                class="cancel-btn"
                on:click={() => (editingPersonal = false)}>Cancel</button
              >
            </div>
          </form>
        {:else}
          <div class="field-group">
            <p>
              First Name: {profile.first_name || "Not set"} (Public: {profile.first_name_public
                ? "Yes"
                : "No"})
            </p>
            <p>
              Last Name: {profile.last_name || "Not set"} (Public: {profile.last_name_public
                ? "Yes"
                : "No"})
            </p>
          </div>
          <div class="field-group">
            <p>
              Username: @{profile.username || "Not set"} (Public: {profile.username_public
                ? "Yes"
                : "No"})
            </p>
            <p>
              Phone Number: {profile.phone_number || "Not set"} (Public: {profile.phone_number_public
                ? "Yes"
                : "No"})
            </p>
          </div>
          <div class="field-group">
            <p>
              Address: {profile.address || "Not set"} (Public: {profile.address_public
                ? "Yes"
                : "No"})
            </p>
            <p>
              Participates in Challenges: {profile.participates_in_challenges
                ? "Yes"
                : "No"} (Public: {profile.participates_in_challenges_public
                ? "Yes"
                : "No"})
            </p>
          </div>
          <div class="field-group">
            <p>
              Gender: {profile.gender || "Not set"} (Public: {profile.gender_public
                ? "Yes"
                : "No"})
            </p>
            <p>
              Date of Birth: {profile.dob || "Not set"} (Public: {profile.dob_public
                ? "Yes"
                : "No"})
            </p>
          </div>
          <div class="field-group">
            <p>
              Height: {formatHeight(profile.height)} (Public: {profile.height_public
                ? "Yes"
                : "No"})
            </p>
            <p>
              Weight: {profile.weight ? `${profile.weight} lbs` : "Not set"} (Public:
              {profile.weight_public ? "Yes" : "No"})
            </p>
          </div>
          <div class="field-group">
            <p>
              Body Fat Percentage: {profile.body_fat_percentage || "Not set"}%
              (Public: {profile.body_fat_percentage_public ? "Yes" : "No"})
            </p>
            <p>
              BMI: {profile.bmi || "Not calculated"} (Public: {profile.bmi_public
                ? "Yes"
                : "No"})
            </p>
          </div>
          <div class="field-group">
            <p>
              BMR: {profile.bmr ? `${profile.bmr} kcal/day` : "Not calculated"} (Public:
              {profile.bmr_public ? "Yes" : "No"})
            </p>
          </div>
          {#if profile.profile_photo_url}
            <div class="field-group">
              <img
                src={profile.profile_photo_url}
                alt="User profile"
                class="profile-photo"
              />
              <p>(Public: {profile.profile_photo_url_public ? "Yes" : "No"})</p>
            </div>
          {/if}
          <button on:click={() => (editingPersonal = true)}>Edit</button>
        {/if}
      </section>

      <section id="account-info" class="container">
        <h2>Account Info</h2>
        {#if editingAccount}
          <form on:submit|preventDefault={changePassword}>
            <div class="field-group">
              <label>
                Email:
                <input type="email" value={$user.email} disabled />
              </label>
              <label>
                Username:
                <input
                  type="text"
                  value="@{profile.username || 'Not set'}"
                  disabled
                />
              </label>
            </div>
            <div class="field-group">
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
            </div>
            <div class="field-group">
              <label>
                Confirm New Password:
                <input
                  type="password"
                  bind:value={passwordForm.confirmPassword}
                  required
                />
              </label>
            </div>
            <div class="buttons">
              <button type="submit">Change Password</button>
              <button
                type="button"
                class="cancel-btn"
                on:click={() => (editingAccount = false)}>Cancel</button
              >
            </div>
          </form>
        {:else}
          <div class="field-group">
            <p>Email: {$user.email}</p>
            <p>Username: @{profile.username || "Not set"}</p>
          </div>
          <button on:click={() => (editingAccount = true)}>Edit</button>
        {/if}
      </section>
    {/if}
  </div>
</div>

<style>
  .profile-page {
    display: flex;
    gap: clamp(1rem, 2vw, 2rem);
    padding: clamp(1rem, 2vw, 2rem);
    max-width: 1200px;
    margin: 0 auto;
  }

  .sidebar {
    width: clamp(100px, 15vw, 200px);
  }

  .sidebar nav {
    display: flex;
    flex-direction: column;
    gap: clamp(0.5rem, 1vw, 1rem);
  }

  .sidebar a {
    text-decoration: none;
    color: var(--charcoal);
    padding: clamp(0.25rem, 1vw, 0.5rem);
    font-size: clamp(0.8rem, 1.5vw, 1rem);
  }

  .sidebar a:hover {
    background-color: var(--light-gray);
  }

  .content {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: clamp(1rem, 2vw, 2rem);
  }

  .container {
    background-color: var(--white);
    padding: clamp(1rem, 2vw, 2rem);
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }

  h2 {
    margin: 0 0 clamp(0.5rem, 1vw, 1rem);
    font-size: clamp(1.2rem, 2vw, 1.5rem);
    color: var(--charcoal);
  }

  form {
    display: flex;
    flex-direction: column;
    gap: clamp(0.5rem, 1vw, 1rem);
  }

  .field-group {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: clamp(0.5rem, 1vw, 1rem);
  }

  label {
    display: flex;
    flex-direction: column;
    gap: 0.25rem;
    font-size: clamp(0.8rem, 1.5vw, 1rem);
  }

  .radio-group {
    display: flex;
    gap: clamp(0.5rem, 1vw, 1rem);
    margin-top: 0.25rem;
  }

  .radio-group label {
    flex-direction: row;
    align-items: center;
    gap: 0.25rem;
  }

  input {
    padding: clamp(0.25rem, 0.5vw, 0.5rem);
    border: 1px solid var(--light-gray);
    border-radius: 4px;
    font-size: clamp(0.7rem, 1.2vw, 1rem);
  }

  p {
    font-size: clamp(0.8rem, 1.5vw, 1rem);
    margin: 0.5rem 0;
  }

  .buttons {
    display: flex;
    gap: clamp(0.5rem, 1vw, 1rem);
    margin-top: clamp(0.5rem, 1vw, 1rem);
  }

  button {
    padding: clamp(0.25rem, 0.5vw, 0.5rem) clamp(0.5rem, 1vw, 1rem);
    border: none;
    border-radius: 4px;
    background-color: var(--carolina-blue);
    color: var(--white);
    cursor: pointer;
    font-size: clamp(0.7rem, 1.2vw, 1rem);
  }

  button:hover {
    background-color: var(--tomato);
  }

  .cancel-btn {
    background-color: var(--gray);
  }

  .cancel-btn:hover {
    background-color: var(--tomato-light);
  }

  .profile-photo {
    max-width: clamp(100px, 20vw, 200px);
    border-radius: 50%;
    margin: clamp(0.5rem, 1vw, 1rem) 0;
  }

  .error {
    color: var(--tomato);
    font-size: clamp(0.8rem, 1.5vw, 1rem);
  }

  @media (max-width: 600px) {
    .profile-page {
      flex-direction: column;
    }

    .sidebar {
      width: 100%;
      margin-bottom: clamp(0.5rem, 1vw, 1rem);
    }

    .sidebar nav {
      flex-direction: row;
      justify-content: space-around;
    }

    .field-group {
      grid-template-columns: 1fr;
    }
  }
</style>
