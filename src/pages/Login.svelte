<script>
  import { supabase } from "../supabase.js";
  import { user } from "../stores/user.js";
  import { navigate } from "svelte-routing";

  let loginId = "";
  let password = "";
  let error = "";

  async function login() {
    const cleanedLoginId =
      loginId.replace(/\D/g, "").length === 10
        ? loginId.replace(/\D/g, "")
        : loginId;
    console.log("Login attempt with:", cleanedLoginId);

    let email = null;
    let phone = null;

    if (/^\d{10}$/.test(cleanedLoginId)) {
      console.log("Detected as phone:", cleanedLoginId);
      phone = cleanedLoginId;
    } else if (cleanedLoginId.includes("@")) {
      console.log("Detected as email:", cleanedLoginId);
      email = cleanedLoginId;
    } else {
      console.log("Detected as username, querying users table...");
      const { data, error: queryError } = await supabase
        .from("users")
        .select("email, phone_number")
        .ilike("username", cleanedLoginId);

      if (queryError) {
        console.error("Query error:", queryError.message);
        error = "Error querying username";
        return;
      }
      console.log("Query result:", data);
      if (!data || data.length === 0) {
        console.log("No user found for username:", cleanedLoginId);
        error = "Invalid username or credentials";
        return;
      }
      if (data.length > 1) {
        console.error("Multiple users found for username:", cleanedLoginId);
        error = "Multiple accounts found; contact support";
        return;
      }
      const userData = data[0];
      console.log("Found user:", userData);
      email = userData.email || null;
      phone = userData.phone_number || null;
      if (!email && !phone) {
        console.log("No email or phone for username:", cleanedLoginId);
        error = "No email or phone associated with this username";
        return;
      }
    }

    if (email) {
      console.log("Attempting login with email:", email);
      const { data, error: authError } = await supabase.auth.signInWithPassword(
        {
          email,
          password,
        }
      );
      if (authError) {
        console.error("Auth error:", authError.message);
        error = authError.message;
      } else {
        console.log("Login successful with email");
        user.set(data.user);
        navigate("/");
      }
    } else if (phone) {
      console.log("Attempting login with phone:", phone);
      const { data, error: authError } = await supabase.auth.signInWithPassword(
        {
          phone,
          password,
        }
      );
      if (authError) {
        console.error("Auth error:", authError.message);
        error = authError.message;
      } else {
        console.log("Login successful with phone");
        user.set(data.user);
        navigate("/");
      }
    } else {
      console.log("No valid email or phone detected");
      error = "Invalid login ID";
    }
  }

  async function forgotPassword() {
    if (!loginId) {
      error = "Please enter your email or phone number";
      return;
    }

    const cleanedLoginId =
      loginId.replace(/\D/g, "").length === 10
        ? loginId.replace(/\D/g, "")
        : loginId;

    if (cleanedLoginId.includes("@")) {
      const { error: err } = await supabase.auth.resetPasswordForEmail({
        email: cleanedLoginId,
      });
      if (err) {
        error = err.message;
      } else {
        error = "Password reset email sent. Check your inbox.";
      }
    } else if (/^\d{10}$/.test(cleanedLoginId)) {
      error = "Password reset via phone number is not supported yet.";
    } else {
      error = "Please enter a valid email or phone number for password reset";
    }
  }

  async function loginWithGoogle() {
    const { error } = await supabase.auth.signInWithOAuth({
      provider: "google",
    });
    if (error) console.error("Google login failed:", error.message);
  }

  async function loginWithFacebook() {
    const { error } = await supabase.auth.signInWithOAuth({
      provider: "facebook",
    });
    if (error) console.error("Facebook login failed:", error.message);
  }

  async function loginWithApple() {
    const { error } = await supabase.auth.signInWithOAuth({
      provider: "Apple",
    });
    if (error) console.error("Apple login failed:", error.message);
  }
</script>

<div class="login">
  <div class="header-container">
    <header>
      <img src="/assets/logo.png" alt="blOb Logo" class="logo" />
      <h1>blOb</h1>
    </header>
  </div>

  {#if error}
    <p class="error">{error}</p>
  {/if}

  <div class="form-container">
    <form on:submit|preventDefault={login}>
      <label for="loginId">Email, Phone, or Username</label>
      <input
        type="text"
        id="loginId"
        bind:value={loginId}
        placeholder="Enter email, phone, or username"
        required
      />
      <label for="password">Password</label>
      <input
        type="password"
        id="password"
        bind:value={password}
        placeholder="Password"
        required
      />
      <button type="submit" class="btn-primary">Login</button>
    </form>
  </div>

  <div class="forgot-password-container">
    <p>
      <a class="link-accent" on:click|preventDefault={forgotPassword}
        >Forgot Password?</a
      >
    </p>
  </div>

  <div class="social-login-container">
    <p>Or log in with:</p>
    <div class="social-buttons">
      <button class="btn-social google" on:click={loginWithGoogle}>
        <img src="/assets/google-icon.png" alt="Google" class="icon" /> Google
      </button>
      <button class="btn-social facebook" on:click={loginWithFacebook}>
        <img src="/assets/facebook-icon.png" alt="Facebook" class="icon" /> Facebook
      </button>
      <button class="btn-social apple" on:click={loginWithApple}>
        <img src="/assets/apple-icon.png" alt="Apple" class="icon" /> Apple
      </button>
    </div>
  </div>

  <div class="nav-container">
    <p>
      Don't have an account? <a
        href="/signup"
        class="link-primary"
        on:click|preventDefault={(e) => {
          e.preventDefault();
          navigate("/signup");
        }}>Sign Up</a
      >
    </p>
  </div>
</div>

<style>
  .login {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 100vh;
    padding: 20px;
  }
  .logo {
    width: 100px;
    margin-bottom: 20px;
  }
  header {
    text-align: center;
    margin-bottom: 20px;
  }
  h1 {
    font-family: Arial, Helvetica, sans-serif;
    color: var(--charcoal);
    margin: 0 0 20px;
  }
  .header-container {
    margin-bottom: 20px;
  }
  .form-container {
    width: 100%;
    max-width: 300px;
    margin-bottom: 15px;
  }
  form {
    display: flex;
    flex-direction: column;
    gap: 10px;
  }
  label {
    display: block;
    margin-bottom: 5px;
    color: var(--charcoal);
  }
  input[type="text"],
  input[type="password"] {
    width: 100%;
    padding: 8px;
    margin-bottom: 10px;
    border: 1px solid var(--lapis-lazuli);
    border-radius: 5px;
    box-sizing: border-box;
  }
  .btn-primary {
    background-color: var(--lapis-lazuli);
    color: var(--charcoal);
    padding: 10px;
    border: 2px solid 0;
    border-radius: 5px;
    cursor: pointer;
    width: 100%;
    font-size: 16px;
  }
  .btn-primary:hover {
    background-color: var(--charcoal);
  }
  .forgot-password-container {
    margin-bottom: 15px;
  }
  .link-accent {
    color: var(--hunyadi-yellow);
    text-decoration: none;
    display: block;
    text-align: center;
    margin-top: 10px;
  }
  .link-accent:hover {
    text-decoration: underline;
  }
  .social-login-container p {
    margin-bottom: 15px;
    text-align: center;
  }
  .social-buttons {
    display: flex;
    justify-content: center;
    gap: 10px;
    flex-wrap: wrap;
  }
  .btn-social {
    color: #fff;
    padding: 10px;
    border: none;
    border-radius: 5px;
    margin: 5px;
    cursor: pointer;
    width: 120px;
    font-size: 14px;
  }
  .google {
    background-color: #fff;
    color: var(--charcoal);
    display: inline-block;
  }
  .facebook {
    background-color: #fff;
    color: var(--charcoal);
    display: inline-block;
  }
  .apple {
    background-color: #fff;
    color: var(--charcoal);
    display: inline-block;
  }
  .icon {
    width: 20px;
    vertical-align: middle;
    margin-right: 5px;
  }
  .nav-container {
    margin-top: 15px;
  }
  .link-primary {
    color: var(--lapis-lazuli);
    text-decoration: none;
  }
  .link-primary:hover {
    text-decoration: underline;
  }
  .error {
    color: var(--tomato);
    text-align: center;
    margin-bottom: 10px;
  }
</style>
