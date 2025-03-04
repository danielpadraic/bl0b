<script>
  import { supabase } from "../supabase.js";
  import { user } from "../stores.js";
  import { navigate } from "svelte-routing";

  let firstName = "";
  let lastName = "";
  let email = "";
  let phoneNumber = "";
  let phoneNumberRaw = "";
  let address = "";
  let username = "";
  let password = "";
  let confirmPassword = "";
  let profilePhotoFile = null;
  let error = "";
  let usernameError = "";
  let passwordMatchError = "";
  let phoneNumberError = "";

  let participatesInChallenges = false;
  let gender = "";
  let dob = "";
  let height = "";
  let weight = "";
  let bodyFatPercentage = null; // Optional, default null

  async function checkUsername() {
    const { data, error: err } = await supabase
      .from("profiles")
      .select("username")
      .eq("username", username);
    if (err) {
      usernameError = "Error checking username availability";
    } else if (data.length > 0) {
      usernameError = "Username is already taken";
    } else {
      usernameError = "";
    }
  }

  function checkPasswordMatch() {
    if (password && confirmPassword && password !== confirmPassword) {
      passwordMatchError = "Passwords do not match";
    } else {
      passwordMatchError = "";
    }
  }

  function formatPhoneNumber(input) {
    const digits = input.replace(/\D/g, "");
    phoneNumberRaw = digits;

    if (digits.length <= 3) {
      phoneNumber = digits;
    } else if (digits.length <= 6) {
      phoneNumber = `(${digits.slice(0, 3)}) ${digits.slice(3)}`;
    } else {
      phoneNumber = `(${digits.slice(0, 3)}) ${digits.slice(3, 6)}-${digits.slice(6, 10)}`;
    }

    if (digits.length > 0 && digits.length < 10) {
      phoneNumberError = "Phone number must be 10 digits";
    } else if (digits.length > 10) {
      phoneNumberError = "Phone number cannot exceed 10 digits";
    } else {
      phoneNumberError = "";
    }
  }

  function handlePhoneInput(event) {
    formatPhoneNumber(event.target.value);
  }

  async function uploadProfilePhoto(userId) {
    if (!profilePhotoFile) return null;

    const fileExt = profilePhotoFile.name.split(".").pop();
    const fileName = `${userId}.${fileExt}`;
    const { error: uploadError } = await supabase.storage
      .from("profile_photos")
      .upload(fileName, profilePhotoFile, { upsert: true });

    if (uploadError) throw uploadError;

    const { data } = supabase.storage
      .from("profile_photos")
      .getPublicUrl(fileName);
    return data.publicUrl;
  }

  async function signUp() {
    if (password !== confirmPassword) {
      error = "Passwords must match";
      return;
    }

    if (phoneNumberRaw.length !== 10) {
      error = "Phone number must be exactly 10 digits";
      return;
    }

    if (
      !firstName ||
      !lastName ||
      !email ||
      !phoneNumberRaw ||
      !address ||
      !username
    ) {
      error =
        "All contact information fields (including username) are required";
      return;
    }

    if (participatesInChallenges && (!gender || !dob || !height || !weight)) {
      error =
        "Gender, Date of Birth, Height, and Weight are required for fitness challenges";
      return;
    }

    console.log("Attempting signup with:", { email, username, phoneNumberRaw });

    const { data: authData, error: authError } = await supabase.auth.signUp({
      email,
      password,
    });

    if (authError) {
      console.error("Auth signup error:", authError.message);
      error = authError.message;
      return;
    }

    console.log("Auth signup successful, user:", authData.user);

    let profilePhotoUrl = null;
    if (profilePhotoFile) {
      profilePhotoUrl = await uploadProfilePhoto(authData.user.id);
    }

    const userData = {
      id: authData.user.id,
      first_name: firstName,
      last_name: lastName,
      phone_number: phoneNumberRaw,
      address,
      username,
      participates_in_challenges: participatesInChallenges,
      email,
      profile_photo_url: profilePhotoUrl,
      first_name_public: true, // Always public
      last_name_public: true, // Always public
      username_public: true, // Always public
    };

    if (participatesInChallenges) {
      userData.gender = gender;
      userData.dob = dob;
      userData.height = parseInt(height) || 0;
      userData.weight = parseInt(weight) || 0;
      userData.body_fat_percentage = bodyFatPercentage; // Optional
      userData.gender_public = true; // Always public
    }

    console.log("Inserting user data into profiles table:", userData);

    const { data: insertData, error: dbError } = await supabase
      .from("profiles")
      .insert([userData]);

    if (dbError) {
      console.error("Database insert error:", dbError.message);
      error = dbError.message;
    } else {
      console.log("User data inserted successfully:", insertData);
      user.set(authData.user);
      navigate("/");
    }
  }
</script>

<div class="signup">
  <h1>Sign Up</h1>
  <form on:submit|preventDefault={signUp}>
    <div class="name-row">
      <div class="name-field">
        <label for="firstName">First Name <span class="required">*</span></label
        >
        <input
          type="text"
          id="firstName"
          bind:value={firstName}
          placeholder="First Name"
          required
        />
      </div>
      <div class="name-field">
        <label for="lastName">Last Name <span class="required">*</span></label>
        <input
          type="text"
          id="lastName"
          bind:value={lastName}
          placeholder="Last Name"
          required
        />
      </div>
    </div>

    <label for="email">Email <span class="required">*</span></label>
    <input
      type="email"
      id="email"
      bind:value={email}
      placeholder="Email"
      required
    />

    <label for="phoneNumber">Phone Number <span class="required">*</span></label
    >
    <input
      type="tel"
      id="phoneNumber"
      bind:value={phoneNumber}
      on:input={handlePhoneInput}
      placeholder="(XXX) XXX-XXXX"
      maxlength="14"
      required
    />
    {#if phoneNumberError}
      <p class="error">{phoneNumberError}</p>
    {/if}

    <label for="address">Address <span class="required">*</span></label>
    <input
      type="text"
      id="address"
      bind:value={address}
      placeholder="Address"
      required
    />

    <label for="username">Username <span class="required">*</span></label>
    <input
      type="text"
      id="username"
      bind:value={username}
      placeholder="Username"
      on:blur={checkUsername}
      required
    />
    {#if usernameError}
      <p class="error">{usernameError}</p>
    {/if}

    <label for="password">Password <span class="required">*</span></label>
    <input
      type="password"
      id="password"
      bind:value={password}
      placeholder="Password"
      on:input={checkPasswordMatch}
      required
    />

    <label for="confirmPassword"
      >Confirm Password <span class="required">*</span></label
    >
    <input
      type="password"
      id="confirmPassword"
      bind:value={confirmPassword}
      placeholder="Confirm Password"
      on:input={checkPasswordMatch}
      required
    />
    {#if passwordMatchError}
      <p class="error">{passwordMatchError}</p>
    {/if}

    <label for="profilePhoto">Profile Photo (optional)</label>
    <input
      type="file"
      id="profilePhoto"
      accept="image/*"
      on:change={(e) => (profilePhotoFile = e.target.files[0])}
    />

    <div class="toggle-container">
      <label for="participatesInChallenges">
        Will you be participating in Fitness Challenges?
      </label>
      <div class="switch">
        <span class="toggle-label no">N</span>
        <input
          type="checkbox"
          id="participatesInChallenges"
          bind:checked={participatesInChallenges}
        />
        <span class="slider"></span>
        <span class="toggle-label yes">Y</span>
      </div>
    </div>

    {#if participatesInChallenges}
      <div class="fitness-row">
        <div class="fitness-field gender-field">
          <fieldset>
            <legend>Gender <span class="required">*</span></legend>
            <div class="radio-option">
              <input
                type="radio"
                id="male"
                name="gender"
                value="Male"
                bind:group={gender}
                required
              />
              <label for="male">Male</label>
            </div>
            <div class="radio-option">
              <input
                type="radio"
                id="female"
                name="gender"
                value="Female"
                bind:group={gender}
                required
              />
              <label for="female">Female</label>
            </div>
          </fieldset>
        </div>
        <div class="fitness-field">
          <label for="height">Height (in) <span class="required">*</span></label
          >
          <input
            type="number"
            id="height"
            bind:value={height}
            placeholder="Height"
            min="0"
            required
            class="small-input"
          />
        </div>
        <div class="fitness-field">
          <label for="weight"
            >Weight (lbs) <span class="required">*</span></label
          >
          <input
            type="number"
            id="weight"
            bind:value={weight}
            placeholder="Weight"
            min="0"
            required
            class="small-input"
          />
        </div>
      </div>

      <label for="dob">Date of Birth <span class="required">*</span></label>
      <input type="date" id="dob" bind:value={dob} required />

      <label for="bodyFat">Body Fat Percentage (optional)</label>
      <input
        type="range"
        id="bodyFat"
        bind:value={bodyFatPercentage}
        min="3"
        max="60"
        step="1"
      />
      <p>{bodyFatPercentage === 60 ? "60%+" : `${bodyFatPercentage}%`}</p>
    {/if}

    <button
      type="submit"
      disabled={usernameError || passwordMatchError || phoneNumberError}
    >
      Sign Up
    </button>
  </form>
  {#if error}
    <p class="error">{error}</p>
  {/if}
</div>

<style>
  .signup {
    padding: 70px 20px 60px;
    min-height: 100vh;
    background-color: var(--background);
  }
  .name-row,
  .fitness-row {
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
  }
  .name-field,
  .fitness-field {
    flex: 1;
    min-width: 120px;
  }
  .gender-field {
    flex: 1.5;
  }
  .small-input {
    max-width: 100px;
  }
  .error {
    color: var(--hunyadi-yellow);
    margin-top: 10px;
    text-align: center;
  }
  .toggle-container {
    display: flex;
    flex-direction: column;
    gap: 10px;
    margin-bottom: 15px;
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
    color: var(--text);
    position: absolute;
    z-index: 3;
  }
  .no {
    left: 10px;
  }
  .yes {
    right: 10px;
  }
  fieldset {
    border: 1px solid var(--charcoal);
    padding: 10px;
    margin-bottom: 0;
  }
  legend {
    font-size: 1rem;
  }
  input[type="radio"] {
    margin-right: 5px;
    width: auto;
  }
  .radio-option {
    display: flex;
    align-items: center;
    gap: 5px;
  }

  @media (min-width: 768px) {
    .signup {
      padding: 80px 40px 70px;
    }
  }
</style>
