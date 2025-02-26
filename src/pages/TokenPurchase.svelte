<script>
  import { supabase } from "../supabase.js";
  import { user } from "../stores/user.js";

  async function purchaseTokens() {
    // Simulate token purchase (Stripe integration later)
    const { error } = await supabase
      .from("users")
      .update({ tokens: (profile?.tokens || 0) + 100 })
      .eq("id", supabase.auth.user().id);
    if (!error) alert("100 Tokens purchased!");
  }
</script>

<div class="token-purchase">
  <h1>Purchase Tokens</h1>
  <button on:click={purchaseTokens}>Buy 100 Tokens</button>
</div>

<style>
  .token-purchase {
    padding: 20px;
    text-align: center;
  }
  button {
    background-color: var(--tomato);
    color: white;
    border: none;
    padding: 10px 20px;
    cursor: pointer;
  }
</style>
