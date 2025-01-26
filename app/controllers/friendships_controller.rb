class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  def create
    @friendship = current_user.friendships.build(friend_id: params[:friend_id], status: "pending")
    if @friendship.save
      flash[:success] = "Friend request sent."
    else
      flash[:alert] = "Unable to send friend request."
    end
    redirect_back fallback_location: root_path
  end

  def update
    @friendship = Friendship.find(params[:id])
    if @friendship.update(status: "accepted")
      flash[:success] = "Friend request accepted."
    else
      flash[:alert] = "Unable to accept friend request."
    end
    redirect_back fallback_location: root_path
  end

  def destroy
    @friendship = Friendship.find(params[:id])
    @friendship.destroy
    flash[:success] = "Friend removed."
    redirect_back fallback_location: root_path
  end
end
