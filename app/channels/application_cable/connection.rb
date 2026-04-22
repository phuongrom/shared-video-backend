module ApplicationCable
  # Authenticates WebSocket connections via JWT token in query params
  # Client connects: ws://host/cable?token=<jwt>
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      token = request.params[:token]
      return reject_unauthorized_connection if token.blank?

      payload = JWT.decode(token, Rails.application.secret_key_base, true, algorithm: "HS256").first
      User.find(payload["user_id"])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      reject_unauthorized_connection
    end
  end
end
