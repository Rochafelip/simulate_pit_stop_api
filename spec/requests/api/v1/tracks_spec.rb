require 'rails_helper'

RSpec.describe "Api::V1::Tracks", type: :request do
  let(:user) do
    User.create!(
      email: 'user@example.com',
      password: 'password123',
      password_confirmation: 'password123',
      name: 'User Teste',
      confirmed_at: Time.current
    )
  end

  let(:auth_headers) do
  post '/auth/sign_in', params: { email: user.email, password: 'password123' }
  {
    'uid' => response.headers['uid'],
    'client' => response.headers['client'],
    'access-token' => response.headers['access-token'],
    'token-type' => 'Bearer',
    'Content-Type' => 'application/json',
    'Accept' => 'application/json'
  }
  end

  let!(:track) do
    Track.create!(
      name: "Interlagos",
      country: "Brazil",
      distance: 4.3,
      number_of_curves: 15,
      elevation_track: 43
    )
  end

  describe "GET /api/v1/tracks" do
    it "retorna todos os tracks" do
      get '/api/v1/tracks'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["tracks"].first["name"]).to eq("Interlagos")
    end
  end

  describe "GET /api/v1/tracks/:id" do
    it "retorna o track solicitado" do
      get "/api/v1/tracks/#{track.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["track"]["name"]).to eq("Interlagos")
    end

    it "retorna 404 se o track não existir" do
      get "/api/v1/tracks/999999"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/v1/tracks" do
    let(:valid_params) do
    {
        track: {
        name: "Monza",
        country: "Itália",
        distance: 5.8,
        number_of_curves: 11,
        elevation_track: 12
        }
    }
    end

  let(:invalid_params) do
    {
      track: {
        name: "",
        distance: -3,
        number_of_curves: -1,
        country: "InvalidCountry"
      }
    }
  end

    it "cria um track com dados válidos" do
    post '/api/v1/tracks', params: valid_params.to_json,
         headers: auth_headers.merge({ 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' })
    expect(response).to have_http_status(:created)
    json = JSON.parse(response.body)
    expect(json["track"]["name"]).to eq("Monza")
  end

    it "não cria track com dados inválidos" do
      post '/api/v1/tracks', params: invalid_params.to_json, headers: auth_headers
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /api/v1/tracks/:id" do
    it "atualiza o track quando autenticado" do
      patch "/api/v1/tracks/#{track.id}", params: { track: { name: "Atualizado" } }.to_json, headers: auth_headers.merge({ 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' })
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["track"]["name"]).to eq("Atualizado")
    end

    it "não atualiza sem autenticação" do
      patch "/api/v1/tracks/#{track.id}", params: { track: { name: "Outro" } }.to_json
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "DELETE /api/v1/tracks/:id" do
    it "deleta o track autenticado" do
      delete "/api/v1/tracks/#{track.id}", headers: auth_headers
      expect(response).to have_http_status(:no_content)
    end

    it "não deleta sem autenticação" do
      delete "/api/v1/tracks/#{track.id}"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
