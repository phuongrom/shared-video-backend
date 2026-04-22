module AuthHelper
  def auth_headers(user)
    token = JwtAuthenticatable.encode(user.id)
    { "Authorization" => "Bearer #{token}" }
  end
end
