class NotificationsController < ApplicationController
  def show
    @notifications = current_user.notifications.includes(event: :record)
  end
  def mark_all_as_read
    current_user.notifications.unread.update_all(read_at: Time.current) # Marks all unread notifications as read
    redirect_back fallback_location: notifications_show_path, notice: "All notifications marked as read."
  end
end
