require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe 'POST /auth/sign_in' do
    let!(:user) { create(:user, password: 'password123', confirmed_at: Time.current) }

    let(:valid_attributes) do
      {
        email: user.email,
        password: 'password123'
      }
    end

    context 'quando o request é válido' do
      before do
        post '/auth/sign_in', params: valid_attributes.to_json, headers: { 'CONTENT_TYPE' => 'application/json' }

        @user = User.find_by(email: valid_attributes[:email])
        @user.confirm if @user.present?
      end

      it 'Criar novo User' do
        expect(@user).to be_present
        expect(response).to have_http_status(:success)
      end

      it 'retorna access token após login' do
        post '/auth/sign_in', params: valid_attributes.to_json, headers: { 'CONTENT_TYPE' => 'application/json' }

        expect(response.headers).to include('access-token')
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
