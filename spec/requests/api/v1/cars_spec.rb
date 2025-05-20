require 'rails_helper'

RSpec.describe "Api::V1::Cars", type: :request do
  let(:user) do
    User.create!(
      email: 'user@example.com',
      password: 'password123',
      password_confirmation: 'password123',
      name: 'User Teste',
      confirmed_at: Time.current
    )
  end

def auth_headers_for(user)
  post '/auth/sign_in', params: { email: user.email, password: 'password123' }
  response.headers.slice('client', 'access-token', 'uid')
    .merge({ 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
end

    let!(:car) do
    Car.create!(
        model: "Ferrari F8",
        fuel_capacity: 150,
        power: 700,
        weight: 1400,
        category: "F1" # categoria válida
    )
    end


  describe "GET /api/v1/cars" do
    it "retorna sucesso e lista de carros" do
      get '/api/v1/cars' # sem autenticação (index não exige)
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
    expect(json['cars']).to be_an(Array)
    expect(json['cars'].first['model']).to eq(car.model)
    end
  end

  describe "GET /api/v1/cars/:id" do
    it "retorna sucesso e o carro solicitado" do
      get "/api/v1/cars/#{car.id}" # show também não exige auth
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['car']['model']).to eq(car.model)
    end

    it "retorna 404 se o carro não existir" do
      get "/api/v1/cars/999999"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/v1/cars" do
    let(:valid_params) do
      {
        car: {
          model: "Lamborghini Huracan",
          fuel_capacity: 120,
          power: 640,
          weight: 1422,
          category: "GT3"
        }
      }
    end

    let(:invalid_params) do
      {
        car: {
          model: "",
          fuel_capacity: -10
        }
      }
    end

    it "cria um carro com dados válidos" do
    headers = auth_headers_for(user)
    post '/api/v1/cars', params: valid_params.to_json, headers: headers

    expect(response).to have_http_status(:created)
    json = JSON.parse(response.body)
    expect(json['car']['model']).to eq("Lamborghini Huracan")
    end

    it "não cria carro com dados inválidos" do
    headers = auth_headers_for(user)
    post '/api/v1/cars', params: invalid_params.to_json, headers: headers

    expect(response).to have_http_status(:unprocessable_entity)
    json = JSON.parse(response.body)
    expect(json['errors']).to be_present
    end
  end

  describe "PATCH /api/v1/cars/:id" do
    let(:update_params) do
      {
        car: {
          model: "Ferrari Updated"
        }
      }
    end

    it "atualiza o carro com dados válidos quando autenticado" do
    headers = auth_headers_for(user)
    patch "/api/v1/cars/#{car.id}", params: update_params.to_json, headers: headers
    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json['car']['model']).to eq("Ferrari Updated")
    end

    it "não atualiza carro com dados inválidos" do
    headers = auth_headers_for(user)
    patch "/api/v1/cars/#{car.id}", params: { car: { model: "" } }.to_json, headers: headers
    expect(response).to have_http_status(:unprocessable_entity)
    json = JSON.parse(response.body)
    expect(json['errors']).to be_present
    end
  end

  describe "DELETE /api/v1/cars/:id" do
    it "deleta o carro quando autenticado" do
    headers = auth_headers_for(user)
    delete "/api/v1/cars/#{car.id}", headers: headers
    expect(response).to have_http_status(:no_content)
    expect(Car.exists?(car.id)).to be_falsey
    end

    it "não permite deletar sem autenticação" do
      delete "/api/v1/cars/#{car.id}"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
