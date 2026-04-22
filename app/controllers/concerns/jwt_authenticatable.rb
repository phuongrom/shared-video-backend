# JWT authentication concern shared by all authenticated controllers
module JwtAuthenticatable
  extend ActiveSupport::Concern

  JWT_SECRET = Rails.application.secret_key_base

  included do
    before_action :authenticate_user!, if: :authentication_required?
  end

  # Generate a JWT token for a user (24h expiry)
  def self.encode(user_id)
    payload = { user_id: user_id, exp: 24.hours.from_now.to_i }
    JWT.encode(payload, JWT_SECRET, "HS256")
  end

  def current_user
    @current_user ||= begin
      payload = JWT.decode(extract_token, JWT_SECRET, true, algorithm: "HS256").first
      User.find(payload["user_id"])
    rescue JWT::ExpiredSignature, JWT::DecodeError, ActiveRecord::RecordNotFound
      nil
    end
  end

  private

  def authenticate_user!
    render json: { error: "Unauthorized" }, status: :unauthorized unless current_user
  end

  # Subclasses can override this to skip authentication
  def authentication_required?
    true
  end

  def extract_token
    request.headers["Authorization"]&.split&.last
  end
end
