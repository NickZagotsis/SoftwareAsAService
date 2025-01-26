class FriendsController < ApplicationController
  def index
    if params[:search].present?
      @friends = User.where("email LIKE ?", "%#{params[:search]}%").limit(9)
    else
      @friends = []
    end
  end

  def show
    friendships_as_user = Friendship.where(user_id: current_user.id)
    friendships_as_friend = Friendship.where(friend_id: current_user.id)
    @friends = User.where(id: (friendships_as_user.pluck(:friend_id) + friendships_as_friend.pluck(:user_id)).uniq)
                   .where.not(id: current_user.id)
    if params[:search].present?
      @friends = @friends.where("email LIKE ?", "%#{params[:search]}%").limit(9)
    end
  end
end
