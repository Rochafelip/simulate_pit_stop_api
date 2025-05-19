module Api
  module V1
    class CarsController < ApplicationController
      before_action :authenticate_user!, only: [ :update, :destroy ]
      before_action :set_car, only: [ :show, :update, :destroy ]
      after_action :verify_authorized, except: [ :index, :show, :create ]
      after_action :verify_policy_scoped, only: :index

      # GET /cars
      def index
        cars = policy_scope(Car)
        render json: cars, each_serializer: Api::V1::CarSerializer, status: :ok
      end

      # GET /cars/:id
      def show
        authorize @car
        render json: @car, serializer: Api::V1::CarSerializer, status: :ok
      end

      # POST /cars
      def create
        @car = Car.new(car_params)
        @car.user = current_user if user_signed_in?
        authorize @car

       if @car.save
          render json: @car, serializer: Api::V1::CarSerializer, status: :created
       else
          render json: { errors: @car.errors.full_messages }, status: :unprocessable_entity
       end
      end

      # PATCH/PUT /cars/:id
      def update
        authorize @car
        if @car.update(car_params)
          render json: @car, serializer: Api::V1::CarSerializer, status: :ok
        else
          render json: { errors: @car.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /cars/:id
      def destroy
        authorize @car
        @car.destroy
        head :no_content
      end

      private

      def set_car
        @car = Car.find(params[:id])
      end

      def car_params
        params.require(:car).permit(:model, :fuel_capacity, :power, :weight, :category)
      end
    end
  end
end
