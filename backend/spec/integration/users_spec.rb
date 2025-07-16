require 'swagger_helper'

RSpec.describe 'Swagger Usuários API', type: :request do
  let(:user) { create(:user, password: 'password123', confirmed_at: Time.current) }

  path '/auth' do
    post 'Cria (cadastra) um novo usuário' do
      tags 'Usuários'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          name: { type: :string },
          password: { type: :string },
          password_confirmation: { type: :string },
          confirm_success_url: { type: :string }
        },
        required: %w[email password password_confirmation name confirm_success_url]
      }

      response(200, 'Usuário criado com sucesso') do
        let(:user) do
          {
            name: 'Usuário de Teste',
            email: 'newuser@example.com',
            password: 'password123',
            password_confirmation: 'password123',
            confirm_success_url: 'http://localhost:3000/confirmation-success'
          }
        end
        run_test!
      end

      response(422, 'Dados inválidos para criação') do
        let(:user) do
          {
            name: '',
            email: '',
            password: '',
            password_confirmation: '',
            confirm_success_url: ''
          }
        end
        run_test!
      end
    end
  end

  path '/auth/sign_in' do
    post 'Loga um usuário' do
      tags 'Usuários'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: %w[email password]
      }

      response(200, 'Login bem-sucedido, tokens retornados no header') do
        let(:credentials) { { email: user.email, password: 'password123' } }
        run_test!
      end

      response(401, 'Login falhou – credenciais inválidas') do
        let(:credentials) { { email: 'wrong@example.com', password: 'wrong' } }
        run_test!
      end
    end
  end

  path '/auth/sign_out' do
    delete 'Desloga um usuário' do
      tags 'Usuários'
      produces 'application/json'
      security [ accessToken: [], client: [], uid: [] ]

      response(200, 'Logout bem-sucedido') do
        before do
          post '/auth/sign_in', params: { email: user.email, password: 'password123' }
        end

        let(:'access-token') { response.headers['access-token'] }
        let(:client) { response.headers['client'] }
        let(:uid) { response.headers['uid'] }

        run_test!
      end

      response(404, 'Token inválido ou já expirado') do
        let(:'access-token') { 'invalid' }
        let(:client) { 'invalid' }
        let(:uid) { 'invalid@example.com' }

        run_test!
      end
    end
  end

  path '/auth/validate_token' do
    get 'Valida se o token atual ainda é válido' do
      tags 'Usuários'
      produces 'application/json'
      security [ accessToken: [], client: [], uid: [] ]

      response(200, 'Token válido') do
        before do
          post '/auth/sign_in', params: { email: user.email, password: 'password123' }
        end

        let(:'access-token') { response.headers['access-token'] }
        let(:client) { response.headers['client'] }
        let(:uid) { response.headers['uid'] }

        run_test!
      end

      response(401, 'Token inválido ou expirado') do
        let(:'access-token') { 'invalid' }
        let(:client) { 'invalid' }
        let(:uid) { 'invalid@example.com' }

        run_test!
      end
    end
  end
end
