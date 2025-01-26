class FriendsController < ApplicationController
  def index
    if params[:search].present?
      @friends = User.where("email LIKE ?", "%#{params[:search]}%").limit(9)
    else
      @friends = []
    end
  end

  def show
  end
end
