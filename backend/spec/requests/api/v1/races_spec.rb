require 'rails_helper'

RSpec.describe "Api::V1::Races", type: :request do
let!(:car)   { create(:car) }
let!(:track) { create(:track) }
let!(:user) { create(:user, password: 'password123', confirmed_at: Time.current) }

    before do
      post '/auth/sign_in', params: { email: user.email, password: 'password123' }

      @auth_headers = {
        'uid' => response.headers['uid'],
        'client' => response.headers['client'],
        'access-token' => response.headers['access-token'],
        'token-type' => 'Bearer',
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      }
    end

    describe "POST /api/v1/races" do
    let(:valid_params) do
      {
        race: {
          car_id: car.id,
          track_id: track.id,
          total_laps: 50,
          fuel_consumption_per_lap: 2.0,
          average_lap_time: 1.8,
          mandatory_pit_stop: true,
          planned_pit_stops: 2,
          race_time_minutes: 60
        }
      }
    end

    it "cria uma corrida com dados válidos" do
      post '/api/v1/races', params: valid_params.to_json, headers: @auth_headers.merge({ 'CONTENT_TYPE' => 'application/json' })

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["race"]["total_laps"]).to eq(50)
    end

    it "não cria corrida com pit stops insuficientes" do
      invalid_params = valid_params.deep_dup
      invalid_params[:race][:planned_pit_stops] = 0

      post '/api/v1/races', params: invalid_params.to_json, headers: @auth_headers.merge({ 'CONTENT_TYPE' => 'application/json' })

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["errors"].values.flatten.join).to match(/Paradas planejadas insuficientes/)
    end
  end

  describe "GET /api/v1/races" do
    it "lista todas as corridas" do
      get '/api/v1/races', headers: @auth_headers
      expect(response).to have_http_status(:ok)
    end
  end
end
