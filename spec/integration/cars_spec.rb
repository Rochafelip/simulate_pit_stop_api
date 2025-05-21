require 'swagger_helper'

RSpec.describe 'Swagger Cars', type: :request do
  path '/api/v1/cars' do
    get('Lista todos os carros') do
      tags 'Carros'
      produces 'application/json'

      response(200, 'lista de carros retornada com sucesso') do
        run_test!
      end
    end
    post('Cria um carro') do
      tags 'Carros'
      consumes 'application/json'
      produces 'application/json'
      security [ accessToken: [], client: [], uid: [] ]  # define segurança só aqui

      parameter name: :car, in: :body, schema: {
        type: :object,
        properties: {
          model: { type: :string },
          fuel_capacity: { type: :integer },
          power: { type: :integer },
          weight: { type: :integer },
          category: { type: :string }
        },
        required: %w[model fuel_capacity power weight category]
      }

      response(201, 'carro criado com sucesso') do
        let(:user) { create(:user, password: 'password123') }
        let(:car) do
          {
            model: 'Ferrari F8',
            fuel_capacity: 100,
            power: 720,
            weight: 1330,
            category: 'GT3'
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

      response(422, 'dados inválidos') do
       let(:user) { create(:user, password: 'password123') }
        let(:car) { { model: '' } }

        before do
          post '/auth/sign_in', params: { email: user.email, password: 'password123' }
        end

        let(:'access-token') { response.headers['access-token'] }
        let(:client) { response.headers['client'] }
        let(:uid) { response.headers['uid'] }

       run_test!
      end
    end

    path '/api/v1/cars/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'ID do carro'

    get('Mostra um carro específico') do
      tags 'Carros'
      produces 'application/json'

      response(200, 'carro encontrado') do
        let(:car) { create(:car) }
        let(:id) { car.id }
        run_test!
      end

      response(404, 'carro não encontrado') do
        let(:id) { '999999' }
        run_test!
      end
    end

    put('Atualiza um carro') do
      tags 'Carros'
      consumes 'application/json'
      produces 'application/json'
      security [ accessToken: [], client: [], uid: [] ]

      parameter name: :car, in: :body, schema: {
        type: :object,
        properties: {
          model: { type: :string },
          fuel_capacity: { type: :integer },
          power: { type: :integer },
          weight: { type: :integer },
          category: { type: :string }
        }
      }

      response(200, 'carro atualizado com sucesso') do
        let(:user) { create(:user, password: 'password123') }
        let(:existing_car) { create(:car) }
        let(:id) { existing_car.id }
        let(:car) { { model: 'Updated Model' } }

          let(:'access-token') do
          post '/auth/sign_in', params: { email: user.email, password: 'password123' }
          response.headers['access-token']
        end

        let(:client) { response.headers['client'] }
        let(:uid) { response.headers['uid'] }

        run_test!
        end

      response(404, 'carro não encontrado') do
        let(:user) { create(:user, password: 'password123') }
        let(:id) { '999999' }
        let(:car) { { model: 'Inexistente' } }

        before do
          post '/auth/sign_in', params: { email: user.email, password: 'password123' }
        end

        let(:'access-token') { response.headers['access-token'] }
        let(:client) { response.headers['client'] }
        let(:uid) { response.headers['uid'] }

        run_test!
      end
    end

    delete('Deleta um carro') do
      tags 'Carros'
      produces 'application/json'
      security [ accessToken: [], client: [], uid: [] ]
      parameter name: :id, in: :path, type: :string

      response(204, 'carro deletado com sucesso') do
        let(:user) { create(:user, password: 'password123') }
        let(:car) { create(:car) }
        let(:id) { car.id }

        before do
          post '/auth/sign_in', params: { email: user.email, password: 'password123' }
        end

        let(:'access-token') { response.headers['access-token'] }
        let(:client) { response.headers['client'] }
        let(:uid) { response.headers['uid'] }

       run_test!
      end
    end
  end
 end
end
