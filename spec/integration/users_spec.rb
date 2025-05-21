# spec/integration/users_spec.rb
require 'swagger_helper'

RSpec.describe 'Swagger Usuários API', type: :request do
  path '/auth/sign_in' do
    post 'Loga um usuário' do
      tags 'Usuários'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'user@example.com' },
          password: { type: :string, example: 'password123' }
        },
        required: ['email', 'password']
      }

      response '200', 'Usuário autenticado' do
        let(:user) { create(:user, password: 'password123', confirmed_at: Time.current) }
        let(:credentials) { { email: user.email, password: 'password123' } }
        run_test!
      end

      response '401', 'Credenciais inválidas' do
        let(:credentials) { { email: 'invalid@example.com', password: 'wrong' } }
        run_test!
      end
    end
  end
end
