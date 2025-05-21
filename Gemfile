source "https://rubygems.org"

gem "rails", "~> 7.2.2", ">= 7.2.2.1"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

# Autenticação
gem "devise", "~> 4.9"
gem "devise_token_auth", "~> 1.2"

# Autorização
gem "pundit"

# Serialização
gem "active_model_serializers", "~> 0.10.0"

# Internacionalização
gem "i18n"

# Países
gem "countries", "~> 7.0"

# CORS
gem "rack-cors"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rspec-rails", "~> 7.1.1"
  gem "database_cleaner-active_record"
  gem "factory_bot_rails"
  gem "rubocop-rails-omakase", require: false
  gem 'rswag-api'
  gem 'rswag-ui'
  gem 'rswag-specs'
end
