<script>
  import { supabase } from "../supabase.js";
  import { user } from "../stores.js"; // Your user store (adjust the path if needed)
  import { navigate } from "svelte-routing"; // For navigation
  import { onMount } from "svelte";

  console.log("User status:", $user);
  let challenges = []; // List of challenges
  let loading = true; // Loading state
  let error = null; // Error state
  let showAuthPrompt = false; // Controls the sign-up/login prompt

  // Fetch public challenges when the page loads
  onMount(async () => {
    try {
      const { data, error } = await supabase
        .from("challenges")
        .select("*")
        .eq("is_private", false);
      if (error) throw error;
      challenges = data;
    } catch (err) {
      error = err.message;
    } finally {
      loading = false;
    }
  });

  // Handle interactions (create, join, view)
  function handleInteraction(action) {
    if (!$user) {
      showAuthPrompt = true; // Show prompt if not logged in
    } else {
      // Add your logic for logged-in users here later
      if (action === "create") {
        alert("Create challenge (add your logic here)");
      } else if (action === "join") {
        alert("Join challenge (add your logic here)");
      } else if (action === "view") {
        alert("View challenge (add your logic here)");
      }
    }
  }

  // Close the prompt
  function closePrompt() {
    showAuthPrompt = false;
  }

  // Navigate to sign-up or login pages
  function goToSignUp() {
    navigate("/signup");
  }

  function goToLogin() {
    navigate("/login");
  }
</script>

<div class="challenge-lobby">
  <h2>Challenge Lobby</h2>

  <!-- Prompt for unauthenticated users -->
  {#if showAuthPrompt}
    <div class="auth-prompt">
      <p>Please sign up or log in to {handleInteraction.action} challenges.</p>
      <button on:click={goToSignUp}>Sign Up</button>
      <button on:click={goToLogin}>Log In</button>
      <button on:click={closePrompt}>Close</button>
    </div>
  {/if}

  <!-- Display challenges -->
  {#if loading}
    <p>Loading challenges...</p>
  {:else if error}
    <p>Error: {error}</p>
  {:else}
    <table>
      <thead>
        <tr>
          <th>Name</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        {#each challenges as challenge}
          <tr>
            <td>{challenge.name}</td>
            <td>
              {#if $user}
                <button on:click={() => handleInteraction("join")}>Join</button>
                <button on:click={() => handleInteraction("view")}>View</button>
              {:else}
                <button on:click={() => handleInteraction("join")}
                  >Join (Login Required)</button
                >
                <button on:click={() => handleInteraction("view")}
                  >View (Login Required)</button
                >
              {/if}
            </td>
          </tr>
        {/each}
      </tbody>
    </table>
  {/if}

  <!-- Create Challenge button -->
  {#if $user}
    <button on:click={() => handleInteraction("create")}
      >Create Challenge</button
    >
  {:else}
    <button on:click={() => handleInteraction("create")}
      >Create Challenge (Login Required)</button
    >
  {/if}

  <!-- Create an Account link for visitors -->
  {#if !$user}
    <div class="create-account-link">
      <p>Not a member yet?</p>
      <button on:click={goToSignUp}>Create an Account</button>
    </div>
  {/if}
</div>

<style>
  .challenge-lobby {
    padding: 20px;
  }
  .auth-prompt {
    border: 1px solid #ccc;
    padding: 10px;
    margin: 10px 0;
    background: #f9f9f9;
  }
  .create-account-link {
    margin-top: 20px;
  }
  table {
    width: 100%;
    border-collapse: collapse;
    margin: 20px 0;
  }
  th,
  td {
    border: 1px solid #ddd;
    padding: 8px;
    text-align: left;
  }
  th {
    background: #f2f2f2;
  }
  button {
    margin: 0 5px;
    padding: 5px 10px;
  }
</style>
