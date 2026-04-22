require "rails_helper"

RSpec.describe "Api::V1::Videos", type: :request do
  describe "GET /api/v1/videos" do
    let!(:videos) { create_list(:video, 3) }

    it "returns paginated videos without authentication" do
      get "/api/v1/videos"
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["videos"].length).to eq(3)
      expect(body["pagination"]).to be_present
    end

    it "returns videos ordered by newest first" do
      get "/api/v1/videos"
      body = JSON.parse(response.body)
      created_ats = body["videos"].map { |v| v["created_at"] }
      expect(created_ats).to eq(created_ats.sort.reverse)
    end

    it "includes shared_by user info" do
      get "/api/v1/videos"
      body = JSON.parse(response.body)
      expect(body["videos"].first["shared_by"]).to include("name", "email")
    end
  end

  describe "POST /api/v1/videos" do
    let!(:user) { create(:user) }
    let(:youtube_url) { "https://www.youtube.com/watch?v=dQw4w9WgXcQ" }
    let(:metadata) { { title: "Rick Astley", thumbnail_url: "https://example.com/thumb.jpg", description: nil } }

    before do
      allow(YoutubeHelper).to receive(:fetch_metadata).and_return(metadata)
    end

    context "when authenticated" do
      it "creates a video and returns it" do
        post "/api/v1/videos", params: { url: youtube_url }, headers: auth_headers(user)
        expect(response).to have_http_status(:created)
        body = JSON.parse(response.body)
        expect(body["video"]["youtube_id"]).to eq("dQw4w9WgXcQ")
        expect(body["video"]["title"]).to eq("Rick Astley")
      end

      it "returns error for invalid YouTube URL" do
        post "/api/v1/videos", params: { url: "https://example.com" }, headers: auth_headers(user)
        expect(response).to have_http_status(422)
      end

      it "returns error when metadata fetch fails" do
        allow(YoutubeHelper).to receive(:fetch_metadata).and_return(nil)
        post "/api/v1/videos", params: { url: youtube_url }, headers: auth_headers(user)
        expect(response).to have_http_status(422)
      end
    end

    context "when unauthenticated" do
      it "returns unauthorized" do
        post "/api/v1/videos", params: { url: youtube_url }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
