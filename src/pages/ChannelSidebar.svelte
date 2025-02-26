<script>
  import { createEventDispatcher } from "svelte";
  import { supabase } from "../supabase.js";
  import { user } from "../stores/user.js";

  const dispatch = createEventDispatcher();
  let channels = [];
  let groups = [];
  let lobbies = [];
  let loading = true;

  // Fetch channels, groups, and lobbies on mount
  onMount(async () => {
    if ($user) {
      const [channelRes, groupRes, lobbyRes] = await Promise.all([
        supabase.from("social_channels").select("*").eq("is_public", true),
        supabase.from("private_groups").select("*"), // Add user-specific filter if needed
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
      <ul>
        {#each channels as channel}
          <li
            on:click={() => selectChannel({ type: "social", ...channel })}
            role="button"
            tabindex="0"
            on:keydown={(e) =>
              e.key === "Enter" &&
              selectChannel({ type: "social", ...channel })}
          >
            #{channel.name}
          </li>
        {/each}
      </ul>
    </section>
    {#if $user}
      <section>
        <h3># Private Groups</h3>
        <ul>
          {#each groups as group}
            <li
              on:click={() => selectChannel({ type: "group", ...group })}
              role="button"
              tabindex="0"
              on:keydown={(e) =>
                e.key === "Enter" && selectChannel({ type: "group", ...group })}
            >
              #{group.name}
            </li>
          {/each}
        </ul>
      </section>
      <section>
        <h3># Challenge Lobbies</h3>
        <ul>
          {#each lobbies as lobby}
            <li
              on:click={() => selectChannel({ type: "lobby", ...lobby })}
              role="button"
              tabindex="0"
              on:keydown={(e) =>
                e.key === "Enter" && selectChannel({ type: "lobby", ...lobby })}
            >
              #{lobby.name} ({lobby.challenges.title})
            </li>
          {/each}
        </ul>
      </section>
    {/if}
  {/if}
</aside>

<style>
  .channel-sidebar {
    width: 250px;
    background-color: var(--charcoal, #333);
    color: var(--white, #fff);
    padding: 1rem;
    position: absolute;
    top: 60px; /* Below header */
    left: 0;
    bottom: 0;
    z-index: 10;
    overflow-y: auto;
  }

  h2,
  h3 {
    margin: 0 0 0.5rem;
  }

  ul {
    list-style: none;
    padding: 0;
  }

  li {
    padding: 0.5rem;
    cursor: pointer;
  }

  li:hover {
    background-color: var(--tomato, #ff6347);
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
