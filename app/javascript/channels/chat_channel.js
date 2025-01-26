import consumer from "./consumer";

const roomId = document.getElementById("messages").dataset.roomId;

const ChatChannel = consumer.subscriptions.create(
  { channel: "ChatChannel", room_id: roomId },
  {
    // Όταν φτάνει το μήνυμα
    received(data) {
      const messagesContainer = document.getElementById("messages");
      if (messagesContainer) {
        messagesContainer.innerHTML += data.message; // Προσθέτει το νέο μήνυμα
      }
    },

    // Συνδρομή σε συγκεκριμένο κανάλι για το room_id
    connected() {
      console.log('Connected to the ChatChannel');
    },

    disconnected() {
      console.log('Disconnected from the ChatChannel');
    }
  }
);

export default ChatChannel;
