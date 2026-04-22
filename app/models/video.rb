class Video < ApplicationRecord
  belongs_to :user

  validates :url, presence: true
  validates :youtube_id, presence: true, uniqueness: true
  validates :title, presence: true

  after_create_commit :broadcast_new_video

  private

  # Broadcast real-time notification to all subscribers
  def broadcast_new_video
    ActionCable.server.broadcast(
      "notifications_channel",
      {
        type: "new_video",
        video_id: id,
        video_title: title,
        thumbnail_url: thumbnail_url,
        shared_by: user.name,
        shared_by_email: user.email,
        created_at: created_at.iso8601
      }
    )
  end
end
