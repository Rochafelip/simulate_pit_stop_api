require 'swagger_helper'

RSpec.describe 'Swagger Races', type: :request do
  let(:user) { create(:user) }
  let(:track) { create(:track) }
  let(:car) { create(:car) }

  path '/api/v1/races' do
    get('Lista de todas as corridas') do
      tags 'Corridas'
      produces 'application/json'
      security [ { accessToken: [], client: [], uid: [] } ]

      let(:'access-token') do
        post '/auth/sign_in', params: { email: user.email, password: 'password123' }
        response.headers['access-token']
      end

      let(:client) { response.headers['client'] }
      let(:uid) { response.headers['uid'] }

      response(200, 'Lista de corridas retornada com sucesso') do
        run_test!
      end
    end

    post('Cria uma corrida') do
      tags 'Corridas'
      consumes 'application/json'
      produces 'application/json'
      security [ accessToken: [], client: [], uid: [] ]

      parameter name: :race, in: :body, schema: {
        type: :object,
        properties: {
          car_id: { type: :integer },
          track_id: { type: :integer },
          total_laps: { type: :integer },
          fuel_consumption_per_lap: { type: :float },
          average_lap_time: { type: :float },
          mandatory_pit_stop: { type: :boolean },
          planned_pit_stops: { type: :integer },
          race_time_minutes: { type: :integer }
        },
        required: %w[car_id track_id total_laps fuel_consumption_per_lap average_lap_time mandatory_pit_stop planned_pit_stops race_time_minutes]
      }

      response(201, 'Corrida criada com sucesso') do
        let(:race) do
          {
            car_id: car.id,
            track_id: track.id,
            total_laps: 50,
            fuel_consumption_per_lap: 2.0,
            average_lap_time: 1.8,
            mandatory_pit_stop: true,
            planned_pit_stops: 2,
            race_time_minutes: 60
          }
        end

        let(:'access-token') do
          post '/auth/sign_in', params: { email: user.email, password: 'password123' }
          response.headers['access-token']
        end

        let(:client) { response.headers['client'] }
        let(:uid) { response.headers['uid'] }

        run_test!
      end

      response(422, 'Corrida com dados inválidos') do
        let(:race) do
          {
            car_id: nil,
            track_id: nil,
            total_laps: 0,
            fuel_consumption_per_lap: -1.0,
            average_lap_time: 0,
            mandatory_pit_stop: nil,
            planned_pit_stops: -2,
            race_time_minutes: -10
          }
        end

        let(:'access-token') do
          post '/auth/sign_in', params: { email: user.email, password: 'password123' }
          response.headers['access-token']
        end

        let(:client) { response.headers['client'] }
        let(:uid) { response.headers['uid'] }

        run_test!
      end
    end
  end

  path '/api/v1/races/{id}' do
    parameter name: :id, in: :path, type: :integer

    get('Mostra uma corrida') do
      tags 'Corridas'
      produces 'application/json'
      security [ accessToken: [], client: [], uid: [] ]

      let(:existing_race) { create(:race, user: user, car: car, track: track) }
      let(:id) { existing_race.id }

      let(:'access-token') do
        post '/auth/sign_in', params: { email: user.email, password: 'password123' }
        response.headers['access-token']
      end

      let(:client) { response.headers['client'] }
      let(:uid) { response.headers['uid'] }

      response(200, 'Detalhes da corrida') do
        run_test!
      end

      response(404, 'Corrida não encontrada') do
        let(:id) { 0 }
        run_test!
      end
    end

    put('Atualiza uma corrida') do
      tags 'Corridas'
      consumes 'application/json'
      produces 'application/json'
      security [ accessToken: [], client: [], uid: [] ]

      let(:existing_race) { create(:race, user: user, car: car, track: track) }
      let(:id) { existing_race.id }

      parameter name: :race, in: :body, schema: {
        type: :object,
        properties: {
          total_laps: { type: :integer },
          planned_pit_stops: { type: :integer }
        },
        required: ['total_laps' 'planned_pit_stops']
      }

      let(:race) { { total_laps: 70, planned_pit_stops: 3 } }

      let(:'access-token') do
        post '/auth/sign_in', params: { email: user.email, password: 'password123' }
        response.headers['access-token']
      end

      let(:client) { response.headers['client'] }
      let(:uid) { response.headers['uid'] }

      response(200, 'Corrida atualizada com sucesso') do
        run_test!
      end

      response(422, 'Falha na atualização') do
        let(:race) { { total_laps: 0 } }
        run_test!
      end
    end

    delete('Remove uma corrida') do
      tags 'Corridas'
      security [ accessToken: [], client: [], uid: [] ]
      produces 'application/json'

      let(:existing_race) { create(:race, user: user, car: car, track: track) }
      let(:id) { existing_race.id }

      let(:'access-token') do
        post '/auth/sign_in', params: { email: user.email, password: 'password123' }
        response.headers['access-token']
      end

      let(:client) { response.headers['client'] }
      let(:uid) { response.headers['uid'] }

      response(204, 'Corrida removida com sucesso') do
        run_test!
      end
    end
  end
end
