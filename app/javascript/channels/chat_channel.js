import consumer from "channels/consumer";

const roomId = document.getElementById("messages").dataset.roomId;

const ChatChannel = consumer.subscriptions.create(
  { channel: "ChatChannel", room_id: roomId },
  {

    received(data) {
      const messagesContainer = document.getElementById("messages");
      if (messagesContainer) {
        messagesContainer.innerHTML += data.message;
      }
    },


    connected() {
      console.log('Connected to the ChatChannel');
    },

    disconnected() {
      console.log('Disconnected from the ChatChannel');
    }
  }
);

export default ChatChannel;
