class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @friend = User.find(params[:friend_id])


    if current_user == @friend
      flash[:alert] = "You cannot send a friend request to yourself."
      redirect_back fallback_location: root_path and return
    end


    if Friendship.exists?(user_id: current_user.id, friend_id: @friend.id) || Friendship.exists?(user_id: @friend.id, friend_id: current_user.id)
      flash[:alert] = "Friend request already exists."
      redirect_back fallback_location: root_path and return
    end


    @friendship = current_user.friendships.build(friend_id: @friend.id, status: "pending")
    if @friendship.save
      flash[:success] = "Friend request sent."
      FriendsNotifier.with(record: @friendship).deliver(User.find(@friend.id))
    else
      flash[:alert] = "Unable to send friend request."
    end
    redirect_back fallback_location: root_path
  end

  # Accept a friend request (Update friendship to "accepted" status)
  def update
    @friendship = Friendship.find(params[:id])


    if @friendship.friend == current_user && @friendship.status == "pending"
      if @friendship.update(status: "accepted")
        flash[:success] = "Friend request accepted."
        FriendsNotifier.with(record: @friendship).deliver(User.find(@friendship.user_id))
      else
        flash[:alert] = "Unable to accept friend request."
      end
    else
      flash[:alert] = "Invalid action."
    end
    redirect_back fallback_location: root_path
  end


  def destroy
    @friendship = Friendship.find(params[:id])

    if @friendship.user == current_user || @friendship.friend == current_user
      @friendship.destroy
      flash[:success] = "Friend removed."
    else
      flash[:alert] = "You cannot remove this friend."
    end
    redirect_back fallback_location: root_path
  end
end
