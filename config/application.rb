require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Barbeque
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # custom
    config.i18n.default_locale = :ru
    config.action_view.field_error_proc = Proc.new { |html_tag, instance|
      html_tag
    }
    config.active_storage.replace_on_assign_to_many = false
    config.asset_host = Rails.application.credentials.development[:asset_host]

  end
end
