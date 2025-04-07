class Api::V1::CarsController < ApplicationController
  before_action :authenticate_user!, only: [:update, :destroy] # Apenas para ações protegidas
  after_action :verify_authorized, except: [:index, :show, :create]
  after_action :verify_policy_scoped, only: :index

  # GET /cars (todos veem)
  def index
    @cars = policy_scope(Car)
    render json: @cars, each_serializer: CarSerializer
  end

  # GET /cars/1 (todos veem)
  def show
    @car = Car.find(params[:id])
    authorize @car
    render json: @car, serializer: CarSerializer
  end

  # POST /cars (qualquer um pode criar)
  def create
    @car = Car.new(car_params)
    @car.user = current_user if user_signed_in? # Associa usuário se estiver logado
    authorize @car

    if @car.save
      render json: @car, serializer: CarSerializer, status: :created
    else
      render json: @car.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /cars/1 (apenas dono/admin)
  def update
    @car = Car.find(params[:id])
    authorize @car
    if @car.update(car_params)
      render json: @car, serializer: CarSerializer
    else
      render json: @car.errors, status: :unprocessable_entity
    end
  end

  # DELETE /cars/1 (apenas dono/admin)
  def destroy
    @car = Car.find(params[:id])
    authorize @car
    @car.destroy
    head :no_content
  end

  private

  def car_params
    params.require(:car).permit(:model, :power, :weight, :fuel_capacity, :category)
  end
end
