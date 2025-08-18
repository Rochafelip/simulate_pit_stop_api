require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module SimulatePitStopApi
  class Application < Rails::Application
    config.load_defaults 7.2

    config.i18n.default_locale = :'pt-BR'
    config.i18n.available_locales = [:en, :'pt-BR']
    config.i18n.fallbacks = true

    config.action_controller.wrap_parameters format: [:json]

    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
    config.middleware.use ActionDispatch::Flash

    config.autoload_lib(ignore: %w[assets tasks])

    # Se estiver usando apenas API, ative:
    config.api_only = true
  end
end
