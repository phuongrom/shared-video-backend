class Video < ApplicationRecord
  belongs_to :user

  validates :url, presence: true
  validates :youtube_id, presence: true, uniqueness: true
  validates :title, presence: true

  after_create_commit :broadcast_new_video

  private

  def broadcast_new_video
    BroadcastVideoJob.perform_later(id)
  end
end
