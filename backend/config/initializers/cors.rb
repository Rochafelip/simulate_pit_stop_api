Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:5173' # ou o domínio do seu front
    resource '*',
      headers: :any,
      expose: %w[access-token expiry token-type uid client],
      methods: [:get, :post, :patch, :put, :delete, :options, :head],
      credentials: true
  end
end
