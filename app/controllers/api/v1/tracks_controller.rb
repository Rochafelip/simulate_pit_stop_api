class Api::V1::TracksController < ApplicationController
  before_action :authenticate_user!, only: [:update, :destroy] # Apenas para ações protegidas
  after_action :verify_authorized, except: [:index, :show, :create]
  after_action :verify_policy_scoped, only: :index

  # GET /tracks (todos veem)
  def index
    @tracks = policy_scope(Track)  # Verifica o escopo de autorização para a lista de tracks
    render json: @tracks, each_serializer: TrackSerializer  # Usando o TrackSerializer para renderizar cada track
  end

  # GET /tracks/1 (todos veem)
  def show
    @track = Track.find(params[:id])
    authorize @track  # Verifica a autorização do usuário para ver a track
    render json: @track, serializer: TrackSerializer  # Usando o TrackSerializer para renderizar o track
  end

  # POST /tracks (qualquer um pode criar)
  def create
    @track = Track.new(track_params)
    @track.user = current_user if user_signed_in?  # Associa o usuário se ele estiver logado
    authorize @track  # Verifica se o usuário pode criar a track

    if @track.save
      render json: @track, status: :created, serializer: TrackSerializer  # Usando TrackSerializer
    else
      render json: @track.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tracks/1 (apenas dono/admin)
  def update
    @track = Track.find(params[:id])
    authorize @track  # Verifica se o usuário pode atualizar a track
    if @track.update(track_params)
      render json: @track, serializer: TrackSerializer  # Usando TrackSerializer
    else
      render json: @track.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tracks/1 (apenas dono/admin)
  def destroy
    @track = Track.find(params[:id])
    authorize @track  # Verifica se o usuário pode deletar a track
    @track.destroy
    head :no_content
  end

  private

  def track_params
    params.require(:track).permit(:name, :location, :length, :difficulty)
  end
end
