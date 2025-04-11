<script>
  import { onMount } from "svelte";
  import { supabase } from "../supabase.js";
  import { user } from "../stores.js";

  let profile = null;
  let loading = true;
  let error = null;
  let editingPersonal = false;
  let editingAccount = false;
  let editingPassword = false; // Separate state for password editing
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
        .select("*")
        .eq("id", $user.id)
        .maybeSingle();

      console.log("Fetch result:", { data, fetchError });

      if (fetchError) throw fetchError;

      if (data) {
        profile = data;
        // Ensure always-public fields are set
        profile.first_name_public = true;
        profile.last_name_public = true;
        profile.username_public = true;
        profile.gender_public = true;
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
          body_fat_percentage: null, // Optional, default null
          profile_photo_url: "",
          bmi: null,
          bmr: null,
          first_name_public: true, // Always public
          last_name_public: true, // Always public
          username_public: true, // Always public
          phone_number_public: false,
          address_public: false,
          participates_in_challenges_public: false,
          gender_public: true, // Always public
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

  function calculateAge(dob) {
    if (!dob) return "Not set";
    const birthDate = new Date(dob);
    const today = new Date();
    let age = today.getFullYear() - birthDate.getFullYear();
    const monthDiff = today.getMonth() - birthDate.getMonth();
    if (
      monthDiff < 0 ||
      (monthDiff === 0 && today.getDate() < birthDate.getDate())
    ) {
      age--;
    }
    return age;
  }

  function calculateBMI(height, weight) {
    if (!height || !weight) return "Not calculated";
    return ((weight / (height * height)) * 703).toFixed(1);
  }

  function calculateBMR(height, weight, gender, dob) {
    if (!height || !weight || !gender || !dob) return "Not calculated";
    const weightKg = weight * 0.453592;
    const heightCm = height * 2.54;
    const age = calculateAge(dob);
    if (gender === "Male") {
      return (10 * weightKg + 6.25 * heightCm - 5 * age + 5).toFixed(0);
    } else if (gender === "Female") {
      return (10 * weightKg + 6.25 * heightCm - 5 * age - 161).toFixed(0);
    }
    return "Not calculated";
  }

  async function updateProfile() {
    try {
      // Enforce required contact fields
      if (
        !profile.first_name ||
        !profile.last_name ||
        !profile.phone_number ||
        !profile.address
      ) {
        throw new Error("All contact information fields are required.");
      }
      // Enforce required physical fields if participating in challenges
      if (profile.participates_in_challenges) {
        if (
          !profile.gender ||
          !profile.dob ||
          !profile.height ||
          !profile.weight
        ) {
          throw new Error(
            "Gender, DOB, Height, and Weight are required when participating in fitness challenges."
          );
        }
      }

      profile.bmi = calculateBMI(profile.height, profile.weight);
      profile.bmr = calculateBMR(
        profile.height,
        profile.weight,
        profile.gender,
        profile.dob
      );

      // Ensure always-public fields remain true
      profile.first_name_public = true;
      profile.last_name_public = true;
      profile.username_public = true;
      profile.gender_public = true;

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

  async function updateUsername() {
    try {
      if (!profile.username) {
        throw new Error("Username is required.");
      }

      // Ensure always-public field remains true
      profile.username_public = true;

      const updates = {
        id: $user.id,
        username: profile.username,
        username_public: true,
      };

      const { error: updateError } = await supabase
        .from("profiles")
        .upsert(updates, { onConflict: "id" });

      if (updateError) throw updateError;

      editingAccount = false;
      alert("Username updated successfully");
    } catch (err) {
      alert("Failed to update username: " + err.message);
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
      editingPassword = false;
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

<div class="profile-page-wrapper">
  <div class="profile-page-container">
    {#if loading}
      <div class="loading-state">
        <p>Loading...</p>
      </div>
    {:else if error}
      <div class="error-state">
        <p class="error">{error}</p>
      </div>
    {:else}
      <div class="profile-container">
        <div class="photo-section">
          {#if profile.profile_photo_url}
            <img
              src={profile.profile_photo_url}
              alt="Profile"
              class="profile-photo"
            />
          {:else}
            <div class="photo-placeholder">No Photo</div>
          {/if}
          <input
            type="file"
            id="profilePhoto"
            accept="image/*"
            on:change={(e) => (profilePhotoFile = e.target.files[0])}
            hidden
          />
          <div class="photo-actions">
            <button
              class="edit-photo-btn"
              on:click={() => document.getElementById("profilePhoto").click()}
            >
              Edit Photo
            </button>
            <button class="upload-btn" on:click={uploadProfilePhoto}>
              Upload
            </button>
          </div>
        </div>

        <div class="details-section">
          <section id="personal-details">
            <h2>Personal Details</h2>

            <h3>Contact Information</h3>
            <table class="info-table">
              <tbody>
                <tr>
                  <th>Name</th>
                  <td>
                    {#if editingPersonal}
                      <input
                        type="text"
                        bind:value={profile.first_name}
                        placeholder="First Name"
                        required
                      />
                      <input
                        type="text"
                        bind:value={profile.last_name}
                        placeholder="Last Name"
                        required
                      />
                    {:else}
                      {profile.first_name} {profile.last_name}
                    {/if}
                  </td>
                  <td>(Always Public)</td>
                </tr>
                <tr>
                  <th>Phone</th>
                  <td>
                    {#if editingPersonal}
                      <input
                        type="text"
                        bind:value={profile.phone_number}
                        placeholder="Phone Number"
                        required
                      />
                    {:else}
                      {profile.phone_number}
                    {/if}
                  </td>
                  <td>
                    {#if editingPersonal}
                      <label>
                        Public: <input
                          type="checkbox"
                          bind:checked={profile.phone_number_public}
                        />
                      </label>
                    {:else}
                      (Public: {profile.phone_number_public ? "Yes" : "No"})
                    {/if}
                  </td>
                </tr>
                <tr>
                  <th>Email</th>
                  <td>{$user.email}</td>
                  <td>(Not editable)</td>
                </tr>
                <tr>
                  <th>Address</th>
                  <td>
                    {#if editingPersonal}
                      <input
                        type="text"
                        bind:value={profile.address}
                        placeholder="Address"
                        required
                      />
                    {:else}
                      {profile.address}
                    {/if}
                  </td>
                  <td>
                    {#if editingPersonal}
                      <label>
                        Public: <input
                          type="checkbox"
                          bind:checked={profile.address_public}
                        />
                      </label>
                    {:else}
                      (Public: {profile.address_public ? "Yes" : "No"})
                    {/if}
                  </td>
                </tr>
              </tbody>
            </table>

            <h3>Physical Details</h3>
            <div class="toggle-container">
              <label for="participatesInChallenges"
                >Participates in Fitness Challenges?</label
              >
              <div class="switch">
                <span class="toggle-label no">N</span>
                <input
                  type="checkbox"
                  id="participatesInChallenges"
                  bind:checked={profile.participates_in_challenges}
                  disabled={!editingPersonal}
                />
                <span class="slider"></span>
                <span class="toggle-label yes">Y</span>
              </div>
              {#if editingPersonal}
                <label>
                  Public: <input
                    type="checkbox"
                    bind:checked={profile.participates_in_challenges_public}
                  />
                </label>
              {/if}
            </div>
            {#if profile.participates_in_challenges}
              <table class="info-table">
                <tbody>
                  <tr>
                    <th>Gender</th>
                    <td>
                      {#if editingPersonal}
                        <div class="radio-group">
                          <label>
                            <input
                              type="radio"
                              bind:group={profile.gender}
                              value="Male"
                              required
                            /> Male
                          </label>
                          <label>
                            <input
                              type="radio"
                              bind:group={profile.gender}
                              value="Female"
                              required
                            /> Female
                          </label>
                        </div>
                      {:else}
                        {profile.gender}
                      {/if}
                    </td>
                    <td>(Always Public)</td>
                  </tr>
                  <tr>
                    <th>DOB (Age)</th>
                    <td>
                      {#if editingPersonal}
                        <input type="date" bind:value={profile.dob} required />
                      {:else}
                        {profile.dob} ({calculateAge(profile.dob)})
                      {/if}
                    </td>
                    <td>
                      {#if editingPersonal}
                        <label>
                          Public: <input
                            type="checkbox"
                            bind:checked={profile.dob_public}
                          />
                        </label>
                      {:else}
                        (Public: {profile.dob_public ? "Yes" : "No"})
                      {/if}
                    </td>
                  </tr>
                  <tr>
                    <th>Height</th>
                    <td>
                      {#if editingPersonal}
                        <input
                          type="number"
                          bind:value={profile.height}
                          min="0"
                          step="1"
                          placeholder="Inches"
                          required
                        />
                      {:else}
                        {formatHeight(profile.height)}
                      {/if}
                    </td>
                    <td>
                      {#if editingPersonal}
                        <label>
                          Public: <input
                            type="checkbox"
                            bind:checked={profile.height_public}
                          />
                        </label>
                      {:else}
                        (Public: {profile.height_public ? "Yes" : "No"})
                      {/if}
                    </td>
                  </tr>
                  <tr>
                    <th>Weight</th>
                    <td>
                      {#if editingPersonal}
                        <input
                          type="number"
                          bind:value={profile.weight}
                          min="0"
                          step="1"
                          placeholder="lbs"
                          required
                        />
                      {:else}
                        {profile.weight ? `${profile.weight} lbs` : "Not set"}
                      {/if}
                    </td>
                    <td>
                      {#if editingPersonal}
                        <label>
                          Public: <input
                            type="checkbox"
                            bind:checked={profile.weight_public}
                          />
                        </label>
                      {:else}
                        (Public: {profile.weight_public ? "Yes" : "No"})
                      {/if}
                    </td>
                  </tr>
                  <tr>
                    <th>Body Fat %</th>
                    <td>
                      {#if editingPersonal}
                        <input
                          type="number"
                          bind:value={profile.body_fat_percentage}
                          min="0"
                          max="100"
                          placeholder="%"
                        />
                      {:else}
                        {profile.body_fat_percentage
                          ? `${profile.body_fat_percentage}%`
                          : "Not set"}
                      {/if}
                    </td>
                    <td>
                      {#if editingPersonal}
                        <label>
                          Public: <input
                            type="checkbox"
                            bind:checked={profile.body_fat_percentage_public}
                          />
                        </label>
                      {:else}
                        (Public: {profile.body_fat_percentage_public
                          ? "Yes"
                          : "No"})
                      {/if}
                    </td>
                  </tr>
                  <tr>
                    <th>BMI</th>
                    <td>{calculateBMI(profile.height, profile.weight)}</td>
                    <td
                      >{editingPersonal
                        ? ""
                        : `(Public: ${profile.bmi_public ? "Yes" : "No"})`}</td
                    >
                  </tr>
                  <tr>
                    <th>BMR</th>
                    <td
                      >{calculateBMR(
                        profile.height,
                        profile.weight,
                        profile.gender,
                        profile.dob
                      )} kcal/day</td
                    >
                    <td
                      >{editingPersonal
                        ? ""
                        : `(Public: ${profile.bmr_public ? "Yes" : "No"})`}</td
                    >
                  </tr>
                </tbody>
              </table>
            {/if}

            {#if editingPersonal}
              <div class="buttons">
                <button on:click={updateProfile}>Save Changes</button>
                <button
                  class="cancel-btn"
                  on:click={() => (editingPersonal = false)}>Cancel</button
                >
              </div>
            {:else}
              <button class="edit-btn" on:click={() => (editingPersonal = true)}
                >Edit Personal Details</button
              >
            {/if}
          </section>

          <section id="account-details">
            <h2>Account Details</h2>
            <table class="info-table">
              <tbody>
                <tr>
                  <th>Username</th>
                  <td>
                    {#if editingAccount}
                      <input
                        type="text"
                        bind:value={profile.username}
                        required
                      />
                    {:else}
                      @{profile.username}
                    {/if}
                  </td>
                  <td>(Always Public)</td>
                </tr>
                {#if editingPassword}
                  <tr>
                    <th>Current Password</th>
                    <td
                      ><input
                        type="password"
                        bind:value={passwordForm.currentPassword}
                        required
                      /></td
                    >
                    <td></td>
                  </tr>
                  <tr>
                    <th>New Password</th>
                    <td
                      ><input
                        type="password"
                        bind:value={passwordForm.newPassword}
                        required
                      /></td
                    >
                    <td></td>
                  </tr>
                  <tr>
                    <th>Confirm New Password</th>
                    <td
                      ><input
                        type="password"
                        bind:value={passwordForm.confirmPassword}
                        required
                      /></td
                    >
                    <td></td>
                  </tr>
                {/if}
              </tbody>
            </table>

            {#if editingAccount}
              <div class="buttons">
                <button on:click={updateUsername}>Save Username</button>
                <button
                  class="cancel-btn"
                  on:click={() => (editingAccount = false)}>Cancel</button
                >
              </div>
            {:else if editingPassword}
              <div class="buttons">
                <button on:click={changePassword}>Save Password</button>
                <button
                  class="cancel-btn"
                  on:click={() => (editingPassword = false)}>Cancel</button
                >
              </div>
            {:else}
              <div class="buttons">
                <button
                  class="edit-btn"
                  on:click={() => (editingAccount = true)}>Edit Username</button
                >
                <button
                  class="edit-btn"
                  on:click={() => (editingPassword = true)}
                  >Change Password</button
                >
              </div>
            {/if}
          </section>
        </div>
      </div>
    {/if}
  </div>
</div>

<style>
  .profile-page-wrapper {
    padding-top: 60px; /* Space for header */
    padding-bottom: 70px; /* Space for footer */
    min-height: 100vh;
    background-color: var(--background);
    overflow-y: auto;
  }

  .profile-page-container {
    max-width: 800px;
    margin: 0 auto;
    padding: 1rem;
  }

  .loading-state,
  .error-state {
    padding: 2rem;
    text-align: center;
  }

  .profile-container {
    display: flex;
    flex-direction: column;
    gap: 2rem;
  }

  .photo-section {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 1rem;
  }

  .profile-photo {
    width: 150px;
    height: 150px;
    border-radius: 50%;
    object-fit: cover;
    border: 2px solid var(--charcoal);
  }

  .photo-placeholder {
    width: 150px;
    height: 150px;
    border-radius: 50%;
    background-color: var(--light-gray);
    display: flex;
    align-items: center;
    justify-content: center;
    color: var(--charcoal);
    font-size: 1.2rem;
    border: 2px dashed var(--gray);
  }

  .photo-actions {
    display: flex;
    gap: 1rem;
    flex-wrap: wrap;
    justify-content: center;
  }

  .edit-photo-btn,
  .upload-btn {
    padding: 0.5rem 1rem;
    border: none;
    border-radius: 4px;
    background-color: var(--carolina-blue);
    color: var(--white);
    cursor: pointer;
    font-size: 1rem;
    transition: background-color 0.3s;
  }

  .edit-photo-btn:hover,
  .upload-btn:hover {
    background-color: var(--tomato);
  }

  .details-section {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 2rem;
  }

  h2 {
    font-size: 1.8rem;
    color: var(--charcoal);
    margin-bottom: 1rem;
    border-bottom: 2px solid var(--tomato);
    padding-bottom: 0.5rem;
  }

  h3 {
    font-size: 1.4rem;
    color: var(--charcoal);
    margin: 1rem 0 0.5rem;
  }

  .info-table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 1rem;
    background-color: var(--white);
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }

  .info-table th,
  .info-table td {
    padding: 0.75rem;
    border: 1px solid var(--light-gray);
    font-size: 1rem;
    text-align: left;
  }

  .info-table th {
    background-color: var(--carolina-blue);
    color: var(--white);
    width: 25%;
  }

  .info-table td {
    background-color: var(--white);
  }

  .toggle-container {
    display: flex;
    align-items: center;
    gap: 1rem;
    margin-bottom: 1rem;
  }

  .switch {
    position: relative;
    display: inline-flex;
    align-items: center;
    width: 60px;
    height: 34px;
  }

  .switch input {
    opacity: 0;
    width: 60px;
    height: 34px;
    position: absolute;
    z-index: 2;
    cursor: pointer;
  }

  .slider {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: #ccc;
    transition: 0.4s;
    border-radius: 34px;
    z-index: 1;
  }

  .slider:before {
    position: absolute;
    content: "";
    height: 26px;
    width: 26px;
    left: 4px;
    bottom: 4px;
    background-color: white;
    transition: 0.4s;
    border-radius: 50%;
  }

  input:checked + .slider {
    background-color: var(--tomato);
  }

  input:checked + .slider:before {
    transform: translateX(26px);
  }

  .toggle-label {
    font-size: 1rem;
    color: var(--charcoal);
    position: absolute;
    z-index: 3;
  }

  .no {
    left: 10px;
  }

  .yes {
    right: 10px;
  }

  .radio-group {
    display: flex;
    gap: 1rem;
  }

  .buttons {
    display: flex;
    gap: 1rem;
    margin-top: 1rem;
    flex-wrap: wrap;
  }

  .edit-btn,
  button {
    padding: 0.5rem 1rem;
    border: none;
    border-radius: 4px;
    background-color: var(--carolina-blue);
    color: var(--white);
    cursor: pointer;
    font-size: 1rem;
    transition: background-color 0.3s;
  }

  .edit-btn:hover,
  button:hover {
    background-color: var(--tomato);
  }

  .cancel-btn {
    background-color: var(--gray);
  }

  .cancel-btn:hover {
    background-color: var(--tomato-light);
  }

  .error {
    color: var(--tomato);
    font-size: 1rem;
    text-align: center;
  }

  @media (max-width: 768px) {
    .profile-page-container {
      padding: 1rem;
    }

    .photo-section {
      flex-direction: column;
      align-items: center;
    }

    .profile-photo,
    .photo-placeholder {
      width: 120px;
      height: 120px;
    }

    .info-table th,
    .info-table td {
      font-size: 0.9rem;
      padding: 0.5rem;
    }
  }
</style>
