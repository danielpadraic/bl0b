<script>
  import { createEventDispatcher } from "svelte";

  // Props
  export let userEmail = "";

  // Event dispatcher for close events
  const dispatch = createEventDispatcher();

  // Handle closing the popup
  function closePopup() {
    dispatch("close");
  }

  // Handle key presses for accessibility
  function handleKeydown(event) {
    if (event.key === "Escape") {
      closePopup();
    }
  }
</script>

<svelte:window on:keydown={handleKeydown} />

<div class="popup-overlay" on:click={closePopup}>
  <div class="popup-content" on:click|stopPropagation>
    <div class="popup-header">
      <h2>Email Verification Required</h2>
      <button class="close-button" on:click={closePopup} aria-label="Close"
        >×</button
      >
    </div>

    <div class="popup-body">
      <div class="icon-container">
        <div class="email-icon">✉️</div>
      </div>

      <p>We've sent a verification email to:</p>
      <p class="email">{userEmail}</p>

      <p class="instruction">
        Please check your inbox and click the verification link to complete your
        registration.
      </p>

      <div class="tips">
        <h3>Can't find the email?</h3>
        <ul>
          <li>Check your spam or junk folder</li>
          <li>Make sure your email address was entered correctly</li>
          <li>Allow a few minutes for the email to arrive</li>
        </ul>
      </div>
    </div>

    <div class="popup-footer">
      <button class="primary-button" on:click={closePopup}>Got it!</button>
    </div>
  </div>
</div>

<style>
  .popup-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(0, 0, 0, 0.6);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 1000;
    backdrop-filter: blur(3px);
  }

  .popup-content {
    background-color: white;
    border-radius: 12px;
    width: 90%;
    max-width: 480px;
    max-height: 90vh;
    overflow-y: auto;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
    display: flex;
    flex-direction: column;
  }

  .popup-header {
    padding: 16px 20px;
    border-bottom: 1px solid var(--light-gray);
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .popup-header h2 {
    margin: 0;
    font-size: 1.5rem;
    color: var(--tomato);
  }

  .close-button {
    background: none;
    border: none;
    font-size: 1.8rem;
    color: var(--gray);
    cursor: pointer;
    padding: 0;
    line-height: 1;
  }

  .popup-body {
    padding: 24px 20px;
    text-align: center;
  }

  .icon-container {
    margin-bottom: 20px;
  }

  .email-icon {
    font-size: 3rem;
    background-color: var(--light-gray);
    width: 80px;
    height: 80px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto;
  }

  .email {
    font-weight: 600;
    font-size: 1.1rem;
    color: var(--charcoal);
    margin-bottom: 20px;
    word-break: break-all;
  }

  .instruction {
    margin-bottom: 24px;
    line-height: 1.5;
  }

  .tips {
    background-color: var(--light-gray);
    border-radius: 8px;
    padding: 16px;
    text-align: left;
    margin-top: 16px;
  }

  .tips h3 {
    font-size: 1.1rem;
    margin: 0 0 12px;
    color: var(--charcoal);
  }

  .tips ul {
    margin: 0;
    padding-left: 20px;
  }

  .tips li {
    margin-bottom: 8px;
    color: var(--text-secondary, var(--gray));
  }

  .tips li:last-child {
    margin-bottom: 0;
  }

  .popup-footer {
    padding: 16px 20px;
    border-top: 1px solid var(--light-gray);
    display: flex;
    justify-content: center;
  }

  .primary-button {
    background-color: var(--tomato);
    color: white;
    border: none;
    border-radius: 8px;
    padding: 12px 24px;
    font-weight: 600;
    font-size: 1rem;
    cursor: pointer;
    transition: background-color 0.2s;
  }

  .primary-button:hover {
    background-color: var(--tomato-light);
  }
</style>
