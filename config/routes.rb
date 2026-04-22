Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # Action Cable WebSocket
  mount ActionCable.server => "/cable"

  namespace :api do
    namespace :v1 do
      # Auth
      post "auth/register", to: "auth#register"
      post "auth/login",    to: "auth#login"
      get  "auth/me",       to: "auth#me"

      # Videos
      resources :videos, only: %i[index create]
    end
  end
end
