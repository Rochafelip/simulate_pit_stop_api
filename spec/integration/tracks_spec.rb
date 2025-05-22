require 'swagger_helper'

RSpec.describe 'Swagger Tracks', type: :request do
  let(:user) { create(:user) }

  let(:'access-token') do
    post '/auth/sign_in', params: { email: user.email, password: 'password123' }
    response.headers['access-token']
  end

  let(:client) { response.headers['client'] }
  let(:uid) { response.headers['uid'] }

  path '/api/v1/tracks' do
    get('Lista de todas as pistas') do
      tags 'Pistas'
      produces 'application/json'
      security [ accessToken: [], client: [], uid: [] ]

      response(200, 'Lista de pistas retornada com sucesso') do
        run_test!
      end
    end

    post('Cria uma pista') do
      tags 'Pistas'
      consumes 'application/json'
      produces 'application/json'
      security [ accessToken: [], client: [], uid: [] ]

      parameter name: :track, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          country: { type: :string },
          distance: { type: :number },
          number_of_curves: { type: :integer },
          elevation_track: { type: :integer }
        },
        required: %w[name country distance number_of_curves elevation_track]
      }

      response(201, 'Pista criada com sucesso') do
        let(:track) do
          {
            name: 'Autódromo Internacional Ayrton Senna',
            country: 'Brasil',
            distance: 3.1,
            number_of_curves: 14,
            elevation_track: 5
          }
        end

        run_test!
      end

      response(422, 'Pista com dados inválidos') do
        let(:track) { { name: '' } }
        run_test!
      end
    end
  end

  path '/api/v1/tracks/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'ID da pista'

    get('Mostra uma pista') do
      tags 'Pistas'
      produces 'application/json'

      response(200, 'Pista encontrada') do
        let(:track) { create(:track) }
        let(:id) { track.id }
        run_test!
      end

      response(404, 'Pista não encontrada') do
        let(:id) { '999999' }
        run_test!
      end
    end

    put('Atualiza uma pista') do
      tags 'Pistas'
      consumes 'application/json'
      produces 'application/json'
      security [ accessToken: [], client: [], uid: [] ]

      parameter name: :track, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          country: { type: :string },
          distance: { type: :number },
          number_of_curves: { type: :integer },
          elevation_track: { type: :integer }
        }
      }

      response(200, 'Pista atualizada com sucesso') do
        let(:existing_track) { create(:track) }
        let(:id) { existing_track.id }
        let(:track) { { name: 'Pista Atualizada' } }

        run_test!
      end

      response(404, 'Pista não encontrada') do
        let(:id) { '999999' }
        let(:track) { { name: 'Inexistente' } }
        run_test!
      end
    end

    delete('Deleta uma pista') do
      tags 'Pistas'
      produces 'application/json'
      security [ accessToken: [], client: [], uid: [] ]

      response(204, 'Pista deletada com sucesso') do
        let(:track) { create(:track) }
        let(:id) { track.id }
        run_test!
      end

      response(404, 'Pista não encontrada') do
        let(:id) { '999999' }
        run_test!
      end
    end
  end
end
