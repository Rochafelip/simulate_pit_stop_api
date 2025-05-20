require 'rails_helper'

RSpec.describe "Api::V1::Races", type: :request do
let!(:car)   { create(:car) }
let!(:track) { create(:track) }
let!(:user) { create(:user, password: 'password123') }

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
            total_laps: 40,
            fuel_consumption_per_lap: 2.0,
            average_lap_time: 1.8,
            mandatory_pit_stop: true,
            planned_pit_stops: 0,
            race_time_minutes: 120
            }
        }
    end

    it "cria uma corrida com dados válidos" do
      post '/api/v1/races', params: valid_params.to_json, headers: @auth_headers
      puts response.body
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["race"]["total_laps"]).to eq(40)
    end

    it "não cria corrida com pit stops insuficientes" do
      invalid_params = valid_params.deep_dup
      invalid_params[:race][:planned_pit_stops] = 0

      post '/api/v1/races', params: invalid_params.to_json, headers: auth_headers
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["errors"].join).to match(/Pit stops insuficientes/)
    end
  end

  describe "GET /api/v1/races" do
    it "lista todas as corridas" do
      get '/api/v1/races', headers: auth_headers
      expect(response).to have_http_status(:ok)
    end
  end
end
