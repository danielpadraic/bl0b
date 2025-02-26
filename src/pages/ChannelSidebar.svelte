<script>
  import { onMount } from "svelte";
  import { createEventDispatcher } from "svelte";
  import { supabase } from "../supabase.js";
  import { user } from "../stores/user.js";

  const dispatch = createEventDispatcher();
  let channels = [];
  let groups = [];
  let lobbies = [];
  let loading = true;

  onMount(async () => {
    if ($user) {
      const [channelRes, groupRes, lobbyRes] = await Promise.all([
        supabase.from("social_channels").select("*").eq("is_public", true),
        supabase.from("private_groups").select("*"),
        supabase.from("challenge_lobbies").select("*, challenges(title)"),
      ]);

      channels = channelRes.data || [];
      groups = groupRes.data || [];
      lobbies = lobbyRes.data || [];
    } else {
      const { data } = await supabase
        .from("social_channels")
        .select("*")
        .eq("is_public", true);
      channels = data || [];
    }
    loading = false;
  });

  function selectChannel(channel) {
    dispatch("select", channel);
  }
</script>

<aside class="channel-sidebar">
  <h2>Channels</h2>
  {#if loading}
    <p>Loading...</p>
  {:else}
    <section>
      <h3># Public Channels</h3>
      <div>
        {#each channels as channel}
          <button
            on:click={() => selectChannel({ type: "social", ...channel })}
          >
            #{channel.name}
          </button>
        {/each}
      </div>
    </section>
    {#if $user}
      <section>
        <h3># Private Groups</h3>
        <div>
          {#each groups as group}
            <button on:click={() => selectChannel({ type: "group", ...group })}>
              #{group.name}
            </button>
          {/each}
        </div>
      </section>
      <section>
        <h3># Challenge Lobbies</h3>
        <div>
          {#each lobbies as lobby}
            <button on:click={() => selectChannel({ type: "lobby", ...lobby })}>
              #{lobby.name} ({lobby.challenges.title})
            </button>
          {/each}
        </div>
      </section>
    {/if}
  {/if}
</aside>

<style>
  .channel-sidebar {
    width: 250px;
    background-color: #333;
    color: white;
    padding: 1rem;
    position: absolute;
    top: 60px;
    left: 0;
    bottom: 0;
    z-index: 10;
    overflow-y: auto;
  }

  button {
    background: none;
    border: none;
    color: white;
    padding: 0.5rem;
    cursor: pointer;
    width: 100%;
    text-align: left;
  }

  button:hover {
    background-color: #ff6347;
  }

  @media (max-width: 768px) {
    .channel-sidebar {
      width: 100%;
      top: 60px;
      bottom: auto;
      height: calc(100vh - 60px);
    }
  }
</style>
