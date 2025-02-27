<script>
  import { supabase } from "../supabase.js";
  import { navigate } from "svelte-routing";

  let email = "";
  let password = "";
  let errorMessage = "";

  async function login() {
    const { error } = await supabase.auth.signInWithPassword({
      email,
      password,
    });
    if (error) {
      errorMessage = error.message;
    } else {
      navigate("/");
    }
  }

  async function forgotPassword() {
    if (!email) {
      errorMessage = "Please enter your email first.";
      return;
    }
    const { error } = await supabase.auth.resetPasswordForEmail(email);
    if (error) {
      errorMessage = error.message;
    } else {
      errorMessage = "Check your email for a password reset link.";
    }
  }
</script>

<div class="login">
  <h1>Login</h1>
  <form on:submit|preventDefault={login}>
    <input type="email" bind:value={email} placeholder="Email" required />
    <input
      type="password"
      bind:value={password}
      placeholder="Password"
      required
    />
    <button type="submit">Login</button>
  </form>
  {#if errorMessage}
    <p class="error">{errorMessage}</p>
  {/if}
  <div class="forgot-password-container">
    <p>
      <button
        class="forgot-password-btn"
        on:click={forgotPassword}
        on:keydown={(e) => e.key === "Enter" && forgotPassword()}
      >
        Forgot Password?
      </button>
    </p>
  </div>
</div>

<style>
  .login {
    max-width: 400px;
    margin: 2rem auto;
    padding: 1rem;
  }

  input {
    width: 100%;
    padding: 0.5rem;
    margin: 0.5rem 0;
  }

  button {
    width: 100%;
    padding: 0.5rem;
    background-color: #333;
    color: white;
    border: none;
  }

  .error {
    color: red;
  }

  .forgot-password-container {
    margin-top: 1rem;
    text-align: center;
  }

  .forgot-password-btn {
    color: #ff6347;
    text-decoration: none;
    background: none;
    border: none;
    padding: 0;
    cursor: pointer;
  }

  .forgot-password-btn:hover {
    text-decoration: underline;
  }
</style>
