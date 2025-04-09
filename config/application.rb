require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SimulatePitStopApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    # Definir o idioma padrão para português (Brasil)
    config.i18n.default_locale = :'pt-BR'

    # Adicionar idiomas adicionais, caso necessário
    config.i18n.available_locales = [:en, :'pt-BR']

    # Definir o fallback de idioma, caso uma tradução não seja encontrada
    config.i18n.fallbacks = true

    # Adiciona o middleware necessário para sessões
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
    config.middleware.use ActionDispatch::Flash

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    config.middleware.use Rack::Cors do
      allow do
        origins "*"
        resource "*",
          headers: :any,
          expose: [ "access-token", "expiry", "token-type", "uid", "client" ],
          methods: [ :get, :post, :options, :delete, :put ]
          end
      end
    config.api_only = true
  end
end
