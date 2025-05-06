require 'rails_helper'

RSpec.describe "Users Endpoints", type: :request do
  describe 'POST /auth' do
    let(:valid_attributes) do
      {
        email: 'user@example.com',
        name: 'User Teste',
        password: 'password123',
        password_confirmation: 'password123',
        confirm_success_url: 'http://localhost:3000/confirmação'
      }
    end

    context 'quando o request é válido' do
      before do
        # Registro do usuário
        post '/auth', params: valid_attributes.to_json, headers: { 'CONTENT_TYPE' => 'application/json' }

        # Diagnóstico para entender o que foi retornado
        puts response.body

        # Buscar o usuário criado
        @user = User.find_by(email: valid_attributes[:email])

        # Confirmação manual do usuário (se foi criado)
        @user.confirm if @user.present?
      end

      it 'Criar novo User' do
        expect(@user).to be_present
        expect(response).to have_http_status(:success)
      end

      it 'retorna access token após login' do
        post '/auth/sign_in', params: {
          email: valid_attributes[:email],
          password: valid_attributes[:password]
        }

        expect(response.headers).to include('access-token')
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
