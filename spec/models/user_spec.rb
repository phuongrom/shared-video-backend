require "rails_helper"

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(50) }

    it "is valid with valid attributes" do
      expect(user).to be_valid
    end

    it "is invalid with malformed email" do
      user.email = "not-an-email"
      expect(user).not_to be_valid
      expect(user.errors[:email]).to be_present
    end

    it "is invalid with password shorter than 6 chars" do
      user.password = "abc"
      expect(user).not_to be_valid
    end
  end

  describe "associations" do
    it { should have_many(:videos).dependent(:destroy) }
  end

  describe "callbacks" do
    it "downcases email before save" do
      user.email = "TEST@EXAMPLE.COM"
      user.save!
      expect(user.email).to eq("test@example.com")
    end
  end

  describe "#authenticate" do
    let!(:persisted_user) { create(:user, password: "secret123") }

    it "returns user with correct password" do
      expect(persisted_user.authenticate("secret123")).to eq(persisted_user)
    end

    it "returns false with wrong password" do
      expect(persisted_user.authenticate("wrong")).to be_falsey
    end
  end
end
