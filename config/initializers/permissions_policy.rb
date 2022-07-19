# Define an application-wide HTTP permissions policy. For further
# information see https://developers.google.com/web/updates/2018/06/feature-policy

Mailjet.configure do |config|
  config.api_key = ENV['MAILJET_API_KEY']
  config.secret_key = ENV['MAILJET_SECRET_KEY']
  config.api_version = "v3.1"
end
