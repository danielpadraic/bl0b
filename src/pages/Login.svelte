<script>
  import { supabase } from "../supabase.js";
  import { navigate } from "svelte-routing";
  import { onMount } from "svelte";
  import { user } from "../stores.js";

  let email = "";
  let password = "";
  let errorMessage = "";
  let loading = false;

  onMount(() => {
    // If user is already logged in, redirect to home
    if ($user) {
      navigate("/", { replace: true });
    }
  });

  async function login() {
    if (!email || !password) {
      errorMessage = "Please enter both email and password.";
      return;
    }

    loading = true;
    errorMessage = "";

    try {
      const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password,
      });

      if (error) throw error;

      console.log("Login successful:", data);
      navigate("/", { replace: true });
    } catch (err) {
      console.error("Login error:", err);
      errorMessage = err.message || "Failed to login. Please try again.";
    } finally {
      loading = false;
    }
  }

  async function forgotPassword() {
    if (!email) {
      errorMessage = "Please enter your email first.";
      return;
    }

    try {
      const { error } = await supabase.auth.resetPasswordForEmail(email);
      if (error) throw error;

      errorMessage = ""; // Clear any existing errors
      alert("Check your email for a password reset link.");
    } catch (err) {
      errorMessage = err.message;
    }
  }
</script>

<div class="login-container">
  <div class="login-card">
    <h1>Login</h1>

    <form on:submit|preventDefault={login}>
      <div class="form-group">
        <label for="email">Email</label>
        <input
          type="email"
          id="email"
          bind:value={email}
          placeholder="your@email.com"
          required
          autocomplete="email"
        />
      </div>

      <div class="form-group">
        <label for="password">Password</label>
        <input
          type="password"
          id="password"
          bind:value={password}
          placeholder="Your password"
          required
          autocomplete="current-password"
        />
      </div>

      {#if errorMessage}
        <div class="error-message">
          {errorMessage}
        </div>
      {/if}

      <button type="submit" class="login-button" disabled={loading}>
        {loading ? "Logging in..." : "Login"}
      </button>

      <div class="auth-links">
        <button
          type="button"
          class="forgot-password-link"
          on:click={forgotPassword}
        >
          Forgot Password?
        </button>

        <a href="/signup" class="signup-link">
          Don't have an account? Sign Up
        </a>
      </div>
    </form>
  </div>
</div>

<style>
  .login-container {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    padding: 20px;
    background-color: var(--background);
  }

  .login-card {
    width: 100%;
    max-width: 400px;
    background-color: white;
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    padding: 30px;
  }

  h1 {
    text-align: center;
    color: var(--tomato);
    margin-bottom: 24px;
    font-size: 1.75rem;
  }

  .form-group {
    margin-bottom: 20px;
  }

  label {
    display: block;
    margin-bottom: 6px;
    font-weight: 500;
    color: var(--charcoal);
  }

  input {
    width: 100%;
    padding: 12px;
    border: 1px solid var(--light-gray);
    border-radius: 4px;
    font-size: 16px;
  }

  input:focus {
    border-color: var(--tomato);
    outline: none;
  }

  .login-button {
    width: 100%;
    padding: 12px;
    background-color: var(--tomato);
    color: white;
    border: none;
    border-radius: 4px;
    font-size: 16px;
    font-weight: 500;
    cursor: pointer;
    margin-top: 10px;
    transition: background-color 0.2s;
  }

  .login-button:hover {
    background-color: var(--tomato-light);
  }

  .login-button:disabled {
    background-color: var(--gray);
    cursor: not-allowed;
  }

  .error-message {
    background-color: #fff0f0;
    color: var(--tomato);
    padding: 10px;
    border-radius: 4px;
    margin-bottom: 16px;
    font-size: 14px;
  }

  .auth-links {
    display: flex;
    flex-direction: column;
    align-items: center;
    margin-top: 20px;
    gap: 12px;
  }

  .forgot-password-link {
    background: none;
    border: none;
    color: var(--lapis-lazuli);
    text-decoration: underline;
    cursor: pointer;
    font-size: 14px;
  }

  .signup-link {
    color: var(--tomato);
    text-decoration: none;
    font-size: 14px;
  }

  .signup-link:hover {
    text-decoration: underline;
  }
</style>
