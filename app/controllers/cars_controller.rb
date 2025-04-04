class CarsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_car, only: [:show, :update, :destroy]

  # GET /cars
  def index
    @cars = current_user.cars
    render json: @cars
  end

  # GET /cars/1
  def show
    render json: @car
  end

  # POST /cars
  def create
    @car = current_user.cars.new(car_params)

    if @car.save
      render json: @car, status: :created
    else
      render json: @car.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /cars/1
  def update
    if @car.update(car_params)
      render json: @car
    else
      render json: @car.errors, status: :unprocessable_entity
    end
  end

  # DELETE /cars/1
  def destroy
    @car.destroy
    head :no_content
  end

  private
    def set_car
      @car = current_user.cars.find(params[:id])
    end

    def car_params
      params.require(:car).permit(:name, :brand, :model, :year)
    end
end
