class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  add_flash_types :success
  @users = User.all

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # Allow 'description' to be added to registration and account update
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :description ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :description ])
  end
end
