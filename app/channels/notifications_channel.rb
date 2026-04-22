# Broadcasts new video share notifications to all connected clients
class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    # Subscribe to global notifications stream (all users get notified)
    stream_from "notifications_channel"
  end

  def unsubscribed
    stop_all_streams
  end
end
