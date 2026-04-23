# Broadcasts new video notification to all Action Cable subscribers via Sidekiq
class BroadcastVideoJob < ApplicationJob
  queue_as :default

  def perform(video_id)
    video = Video.includes(:user).find_by(id: video_id)
    return unless video

    ActionCable.server.broadcast(
      "notifications_channel",
      {
        type: "new_video",
        video_id: video.id,
        video_title: video.title,
        thumbnail_url: video.thumbnail_url,
        shared_by: video.user.name,
        shared_by_id: video.user.id,
        shared_by_email: video.user.email,
        created_at: video.created_at.iso8601
      }
    )
  end
end
