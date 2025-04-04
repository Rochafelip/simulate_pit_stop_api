class RacesController < ApplicationController
  before_action :authenticate_user! # Exige autenticação
  before_action :set_race, only: [:show, :update, :destroy]

  # GET /races
  def index
    @races = current_user.races # Lista apenas corridas do usuário logado
    render json: @races
  end

  # GET /races/1
  def show
    render json: @race
  end

  # POST /races
  def create
    @race = current_user.races.new(race_params)

    if @race.save
      render json: @race, status: :created
    else
      render json: @race.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /races/1
  def update
    if @race.update(race_params)
      render json: @race
    else
      render json: @race.errors, status: :unprocessable_entity
    end
  end

  # DELETE /races/1
  def destroy
    @race.destroy
    head :no_content
  end

  private
    # Encontra a corrida do usuário atual
    def set_race
      @race = current_user.races.find(params[:id])
    end

    # Filtra parâmetros permitidos
    def race_params
      params.require(:race).permit(:name, :best_lap, :total_time, :car_id, :track_id)
    end
end
