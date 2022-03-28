require_relative 'boot'
require 'rails/all'

Bundler.require(*Rails.groups)

module BoardApp
  class Application < Rails::Application
    config.time_zone = 'UTC'
    # config.active_record.default_timezone = :local

    config.i18n.available_locales = %i(ja en)
    config.i18n.enforce_available_locales = true
    config.i18n.default_locale = :ja
    config.action_controller.include_all_helpers = false

    I18n.load_path += Dir[Rails.root.join("config/locales/*.{rb,yml}")]

  end
end