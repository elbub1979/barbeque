# Define an application-wide HTTP permissions policy. For further
# information see https://developers.google.com/web/updates/2018/06/feature-policy

Mailjet.configure do |config|
  config.api_key = Rails.application.credentials.mailjet[:api_key]
  config.secret_key = Rails.application.credentials.mailjet[:secret_key]
  config.api_version = "v3.1"
end
