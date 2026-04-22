require "rails_helper"

RSpec.describe "Api::V1::Auth", type: :request do
  describe "POST /api/v1/auth/register" do
    let(:valid_params) { { name: "Test User", email: "test@example.com", password: "password123" } }

    context "with valid params" do
      it "creates user and returns token" do
        post "/api/v1/auth/register", params: valid_params
        expect(response).to have_http_status(:created)
        body = JSON.parse(response.body)
        expect(body["token"]).to be_present
        expect(body["user"]["email"]).to eq("test@example.com")
      end
    end

    context "with duplicate email" do
      before { create(:user, email: "test@example.com") }

      it "returns unprocessable entity" do
        post "/api/v1/auth/register", params: valid_params
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)["errors"]).to be_present
      end
    end

    context "with invalid email" do
      it "returns 422" do
        post "/api/v1/auth/register", params: valid_params.merge(email: "bad-email")
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "POST /api/v1/auth/login" do
    let!(:user) { create(:user, email: "login@example.com", password: "secret123") }

    context "with valid credentials" do
      it "returns token and user" do
        post "/api/v1/auth/login", params: { email: "login@example.com", password: "secret123" }
        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body["token"]).to be_present
        expect(body["user"]["id"]).to eq(user.id)
      end
    end

    context "with wrong password" do
      it "returns unauthorized" do
        post "/api/v1/auth/login", params: { email: "login@example.com", password: "wrong" }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with non-existent email" do
      it "returns unauthorized" do
        post "/api/v1/auth/login", params: { email: "ghost@example.com", password: "whatever" }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /api/v1/auth/me" do
    let!(:user) { create(:user) }

    it "returns current user when authenticated" do
      get "/api/v1/auth/me", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["user"]["id"]).to eq(user.id)
    end

    it "returns unauthorized without token" do
      get "/api/v1/auth/me"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
