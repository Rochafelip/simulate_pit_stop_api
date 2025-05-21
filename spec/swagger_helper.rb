# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Pasta onde o Swagger JSON/YAML será gerado
  config.openapi_root = Rails.root.join('swagger').to_s

  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      components: {
        securitySchemes: {
          accessToken: {
            type: :apiKey,
            in: :header,
            name: 'access-token'
          },
          client: {
            type: :apiKey,
            in: :header,
            name: 'client'
          },
          uid: {
            type: :apiKey,
            in: :header,
            name: 'uid'
          }
        }
      },
      # REMOVIDO security global para não exigir token em todas as rotas
      paths: {},
      servers: [
        {
          url: 'https://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'www.example.com'
            }
          }
        }
      ]
    }
  }

  # Formato de saída do swagger
  config.openapi_format = :yaml
end
