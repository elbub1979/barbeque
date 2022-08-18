Rails.application.config.middleware.use OmniAuth::Builder do
  OmniAuth.config.allowed_request_methods = [:get]
  provider :github, Rails.application.credentials.omniauth.development.github[:client_id],
           Rails.application.credentials.omniauth.development.github[:client_secret]
end