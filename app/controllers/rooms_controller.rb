class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room, only: [ :show, :destroy ]

  # Εμφάνιση όλων των Rooms
  def index
    @rooms = Room.where("room_type = 'public'")
  end

  def personal
    @rooms = Room.where("room_type = 'private' and id IN (?)", current_user.rooms.ids)
  end

  # Εμφάνιση συγκεκριμένου Room και των Messages του
  def show
    @room = Room.find(params[:id])
    if @room.room_type == "private" && !@room.users.include?(current_user)
      redirect_to root_path, alert: "You do not have permission to view this chat."
    else
      @messages = @room.messages.order(created_at: :asc)
    end
  end


  # Δημιουργία Room
  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    @room.user_id = current_user.id
    @room.room_type = params[:room_type] || "public"
    @room.users << current_user # Συνδέουμε τον τρέχοντα χρήστη με το νέο δωμάτιο

    if @room.save
      redirect_to @room, notice: "Το δωμάτιο δημιουργήθηκε επιτυχώς!"
    else
      render :new, alert: "Κάτι πήγε στραβά. Δοκιμάστε ξανά."
    end
  end

  def private_chat
    recipient = User.find(params[:recipient_id])

    # Check if a private room already exists between the two users
    existing_room = Room.where(room_type: "private")
                        .joins(:users)
                        .where(users: { id: [ current_user.id, recipient.id ] })
                        .group("rooms.id")
                        .having("COUNT(users.id) = 2") # Ensure both users are in the same room
                        .first

    if existing_room
      # Redirect to the existing room
      redirect_to room_path(existing_room)
    else
      # Create a new room if none exists
      @room = Room.create(name: "#{current_user.email} - #{recipient.email}", room_type: "private", user_id: current_user.id)
      @room.users << current_user
      @room.users << recipient
      redirect_to room_path(@room), notice: "New chat created!"
    end
  end



  def destroy
    if @room.user_id == current_user.id
      @room.destroy
      flash[:notice] = "Room successfully deleted."
      redirect_to rooms_path
    else
      flash[:alert] = "You are not authorized to delete this room."
      redirect_to room_path(@room)
    end
  end
  private
  def set_room
    @room = Room.find(params[:id])
  end
  def room_params
    params.require(:room).permit(:name)
  end
end
