module Api
  module V1
    class AuthController < ApplicationController
      include JwtAuthenticatable

      skip_before_action :authenticate_user!, only: %i[register login]

      def register
        user = User.new(user_params)
        if user.save
          token = JwtAuthenticatable.encode(user.id)
          render json: { token: token, user: user_json(user) }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def login
        user = User.find_by(email: params[:email]&.downcase)
        if user&.authenticate(params[:password])
          token = JwtAuthenticatable.encode(user.id)
          render json: { token: token, user: user_json(user) }
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      def me
        render json: { user: user_json(current_user) }
      end

      private

      def user_params
        params.permit(:email, :name, :password)
      end

      def user_json(user)
        { id: user.id, email: user.email, name: user.name }
      end
    end
  end
end
