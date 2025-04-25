<script>
  import { onMount, onDestroy } from "svelte";
  import { user } from "../stores.js";
  import { supabase } from "../supabase.js";
  import { navigate } from "svelte-routing";

  export let threadId;

  let messages = [];
  let newMessage = "";
  let participants = [];
  let loading = true;
  let error = null;

  onMount(async () => {
    await fetchMessages();
    await fetchParticipants();

    // Subscribe to new messages
    const messagesChannel = supabase
      .channel(`messages:thread_${threadId}`)
      .on(
        "postgres_changes",
        {
          event: "INSERT",
          schema: "public",
          table: "messages",
          filter: `thread_id=eq.${threadId}`,
        },
        (payload) => {
          messages = [...messages, payload.new];
          markAsRead(payload.new.id);
        }
      )
      .subscribe();

    return () => {
      supabase.removeChannel(messagesChannel);
    };
  });

  async function fetchMessages() {
    try {
      const { data, error: fetchError } = await supabase
        .from("messages")
        .select("*")
        .eq("thread_id", threadId)
        .order("created_at", { ascending: true });

      if (fetchError) throw fetchError;
      messages = data || [];
      loading = false;
    } catch (err) {
      console.error("Error fetching messages:", err);
      error = err.message;
      loading = false;
    }
  }

  async function fetchParticipants() {
    try {
      const { data, error: fetchError } = await supabase
        .from("thread_participants")
        .select("user_id, profiles:user_id(username, profile_photo_url)")
        .eq("thread_id", threadId);

      if (fetchError) throw fetchError;
      participants =
        data?.map((p) => ({
          id: p.user_id,
          username: p.profiles?.username || "Unknown",
          profile_photo_url: p.profiles?.profile_photo_url,
        })) || [];
    } catch (err) {
      console.error("Error fetching participants:", err);
    }
  }

  async function sendMessage() {
    if (!newMessage.trim()) return;

    try {
      const { data, error: sendError } = await supabase
        .from("messages")
        .insert([
          {
            thread_id: threadId,
            user_id: $user.id,
            content: newMessage,
            created_at: new Date().toISOString(),
          },
        ])
        .single();

      if (sendError) throw sendError;

      // Update thread's last message preview
      await supabase
        .from("message_threads")
        .update({
          last_message_preview: newMessage.substring(0, 50),
          updated_at: new Date().toISOString(),
        })
        .eq("id", threadId);

      newMessage = "";
    } catch (err) {
      console.error("Error sending message:", err);
      error = err.message;
    }
  }

  async function markAsRead(messageId) {
    try {
      await supabase
        .from("thread_participants")
        .update({ last_read_at: new Date().toISOString() })
        .eq("thread_id", threadId)
        .eq("user_id", $user.id);
    } catch (err) {
      console.error("Error marking as read:", err);
    }
  }
</script>

<div class="message-thread">
  {#if loading}
    <div class="loading">Loading messages...</div>
  {:else if error}
    <div class="error">{error}</div>
  {:else}
    <div class="messages-container">
      {#each messages as message}
        <div
          class="message {message.user_id === $user?.id ? 'sent' : 'received'}"
        >
          {#if message.user_id !== $user?.id}
            <div class="avatar">
              {#if getParticipantPhoto(message.user_id)}
                <img src={getParticipantPhoto(message.user_id)} alt="Profile" />
              {:else}
                <div class="avatar-placeholder">
                  {getParticipantInitials(message.user_id)}
                </div>
              {/if}
            </div>
          {/if}
          <div class="message-bubble">
            <div class="message-content">{message.content}</div>
            <div class="message-time">
              {formatTime(message.created_at)}
            </div>
          </div>
        </div>
      {/each}
    </div>

    <div class="message-input">
      <textarea
        bind:value={newMessage}
        placeholder="Type a message..."
        on:keydown={(e) => e.key === "Enter" && !e.shiftKey && sendMessage()}
      ></textarea>
      <button on:click={sendMessage}>Send</button>
    </div>
  {/if}
</div>

<style>
  .message-thread {
    display: flex;
    flex-direction: column;
    height: 100%;
    background-color: var(--background);
  }

  .messages-container {
    flex: 1;
    overflow-y: auto;
    padding: 1rem;
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
  }

  .message {
    display: flex;
    align-items: flex-end;
    margin-bottom: 8px;
  }

  .message.sent {
    justify-content: flex-end;
  }

  .message.received {
    justify-content: flex-start;
  }

  .avatar {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    overflow: hidden;
    margin-right: 8px;
  }

  .avatar img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  .avatar-placeholder {
    width: 100%;
    height: 100%;
    background-color: var(--carolina-blue);
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 14px;
    font-weight: bold;
  }

  .message-bubble {
    max-width: 70%;
    padding: 8px 12px;
    border-radius: 16px;
  }

  .message.sent .message-bubble {
    background-color: var(--tomato);
    color: white;
    border-bottom-right-radius: 4px;
  }

  .message.received .message-bubble {
    background-color: var(--light-gray);
    color: var(--charcoal);
    border-bottom-left-radius: 4px;
  }

  .message-content {
    white-space: pre-wrap;
    word-break: break-word;
  }

  .message-time {
    font-size: 0.7rem;
    opacity: 0.7;
    text-align: right;
    margin-top: 2px;
  }

  .message-input {
    display: flex;
    padding: 12px;
    background-color: white;
    border-top: 1px solid var(--light-gray);
  }

  textarea {
    flex: 1;
    border: 1px solid var(--light-gray);
    border-radius: 20px;
    padding: 8px 12px;
    resize: none;
    min-height: 40px;
    max-height: 100px;
    margin-right: 8px;
  }

  button {
    background-color: var(--tomato);
    color: white;
    border: none;
    border-radius: 50%;
    width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
  }

  .loading,
  .error {
    padding: 20px;
    text-align: center;
  }

  .error {
    color: var(--tomato);
  }
</style>
