require "rails_helper"

RSpec.describe Video, type: :model do
  subject(:video) { build(:video) }

  describe "validations" do
    it { should validate_presence_of(:url) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:youtube_id) }
    it { should validate_uniqueness_of(:youtube_id) }

    it "is valid with valid attributes" do
      expect(video).to be_valid
    end
  end

  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "broadcast" do
    it "broadcasts to notifications_channel after create" do
      user = create(:user)
      expect {
        create(:video, user: user)
      }.to have_broadcasted_to("notifications_channel")
        .with(hash_including(type: "new_video"))
    end
  end
end
