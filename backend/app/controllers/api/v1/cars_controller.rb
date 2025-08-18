module Api
  module V1
    class CarsController < ApplicationController
      before_action :set_car, only: %i[show update destroy]
      before_action :authenticate_api_v1_user!, except: %i[index show]
      before_action :ensure_json_request

      after_action :verify_authorized, except: %i[index]
      after_action :verify_policy_scoped, only: :index

      # GET /api/v1/cars
      def index
        cars = policy_scope(Car)
        render json: cars, each_serializer: Api::V1::CarSerializer, status: :ok
      end

      # GET /api/v1/cars/:id
      def show
        authorize @car
        render json: @car, serializer: Api::V1::CarSerializer, status: :ok
      end

      # POST /api/v1/cars
      def create
        @car = Car.new(permitted_attributes(Car))
        authorize @car

        if @car.save
          render json: @car, serializer: Api::V1::CarSerializer, status: :created
        else
          render json: { errors: @car.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PUT/PATCH /api/v1/cars/:id
      def update
        authorize @car

        if @car.update(permitted_attributes(@car))
          render json: @car, serializer: Api::V1::CarSerializer, status: :ok
        else
          render json: { errors: @car.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/cars/:id
      def destroy
        authorize @car
        @car.destroy
        head :no_content
      end

      private

      def ensure_json_request
        return if request.format.json?

        render body: nil, status: :not_acceptable
      end

      def set_car
        @car = Car.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Carro não encontrado' }, status: :not_found
      end
    end
  end
end
