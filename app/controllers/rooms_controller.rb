class RoomsController < ApplicationController
  before_action :authenticate_user!

  # Εμφάνιση όλων των Rooms
  def index
    @rooms = Room.all
  end

  # Εμφάνιση συγκεκριμένου Room και των Messages του
  def show
    @room = Room.find(params[:id])
    @messages = @room.messages.order(created_at: :asc) # Φόρτωσε τα μηνύματα με σειρά δημιουργίας
  end


  # Δημιουργία Room
  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    @room.user_id = current_user.id
    @room.users << current_user # Συνδέουμε τον τρέχοντα χρήστη με το νέο δωμάτιο

    if @room.save
      redirect_to @room, notice: "Το δωμάτιο δημιουργήθηκε επιτυχώς!"
    else
      render :new, alert: "Κάτι πήγε στραβά. Δοκιμάστε ξανά."
    end
  end

  private

  def room_params
    params.require(:room).permit(:name)
  end
end
