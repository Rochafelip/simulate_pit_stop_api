class Api::V1::RacesController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, except: [ :index, :show, :create ]
  after_action :verify_policy_scoped, only: :index

  # GET /races (apenas admin pode ver todas, usuários veem apenas suas próprias races)
  def index
    @races = policy_scope(Race)  # A política de escopo limita a visualização da lista
    render json: @races
  end

  # GET /races/:id (usuário pode ver apenas sua própria race, admin pode ver qualquer uma)
  def show
    @race = Race.find(params[:id])
    authorize @race  # Autoriza o acesso à race
    render json: @race
  end

  # POST /races (qualquer usuário logado pode criar uma race)
  def create
    @race = Race.new(race_params)
    @race.user = current_user

    @race.total_fuel_needed = @race.total_laps * @race.fuel_consumption_per_lap

    if @race.save
      render json: @race, status: :created
    else
      render json: @race.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /races/:id (apenas dono ou admin pode atualizar)
  def update
    @race = Race.find(params[:id])
    authorize @race  # Autoriza a atualização da race
    if @race.update(race_params)
      render json: @race
    else
      render json: @race.errors, status: :unprocessable_entity
    end
  end

  # DELETE /races/:id (apenas dono ou admin pode deletar)
  def destroy
    @race = Race.find(params[:id])
    authorize @race  # Autoriza a exclusão da race
    @race.destroy
    head :no_content
  end

  private

  params.require(:race).permit(
    :car_id, :car_name, :car_category,
    :track_id, :track_name,
    :total_laps, :race_time_minutes,
    :fuel_consumption_per_lap, :average_lap_time,
    :total_fuel_needed, :mandatory_pit_stop, :planned_pit_stops
  )
end
