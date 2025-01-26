class ChatChannel < ApplicationCable::Channel
  def subscribed
    @room = Room.find(params[:room_id])
    stream_for @room # Παρακολουθούμε τα μηνύματα του room
  end

  def unsubscribed
    # Καθαρισμός όταν ο χρήστης αποσυνδεθεί
  end
end
