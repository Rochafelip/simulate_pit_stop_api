class Api::V1::RacesController < ApplicationController
  before_action :authenticate_user!, only: [:update, :destroy] # Protege as ações de update e destroy
  after_action :verify_authorized, except: [:index, :show, :create]
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
    @race.user = current_user # Associa a race ao usuário logado
    authorize @race  # Autoriza a criação da race

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

  def race_params
    params.require(:race).permit(:name, :start_time, :location)
  end
end
