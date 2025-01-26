class SessionsController < ApplicationController
  def create
    user = User.find_for_database_authentication(email: params[:email])
    if user&.valid_password?(params[:password])
      sign_in user
      render json: { message: "Logged in successfully" }
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def destroy
    sign_out current_user
    render json: { message: "Logged out successfully" }
  end
end
