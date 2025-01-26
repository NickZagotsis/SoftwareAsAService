class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    @latest_posts = Post.order(created_at: :desc).limit(3)
    @latest_private_rooms = Room.where(room_type: "private").where("name LIKE ?", "%#{current_user.email}%").order(created_at: :desc).limit(3)
  end
end
