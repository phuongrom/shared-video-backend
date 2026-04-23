require "rails_helper"

RSpec.describe BroadcastVideoJob, type: :job do
  describe "#perform" do
    let!(:user) { create(:user) }
    let!(:video) { create(:video, user: user) }

    it "broadcasts to notifications_channel with correct payload" do
      expect {
        described_class.perform_now(video.id)
      }.to have_broadcasted_to("notifications_channel")
        .with(hash_including(
          type: "new_video",
          video_id: video.id,
          video_title: video.title,
          shared_by: user.name,
          shared_by_id: user.id,
          shared_by_email: user.email
        ))
    end

    it "does nothing when video does not exist" do
      expect {
        described_class.perform_now(-1)
      }.not_to have_broadcasted_to("notifications_channel")
    end
  end
end
