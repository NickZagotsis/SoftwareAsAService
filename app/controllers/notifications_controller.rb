class NotificationsController < ApplicationController
  before_action :authenticate_user!
  def show
    @notifications = current_user.notifications.includes(event: :record)
  end

  def mark_all_as_read
    current_user.notifications.unread.update_all(read_at: Time.current) # Marks all unread notifications as read
    redirect_back fallback_location: notifications_show_path, notice: "All notifications marked as read."
  end

  def accept_request
    notification = current_user.notifications.includes(event: :record).find(params[:id])
    friendship = notification.event.record
    notification.update(read_at: Time.current)
    friendship.update(status: "accepted")
  end
end
