module Api
  module V1
class TracksController < ApplicationController
  before_action :authenticate_user!, only: [ :update, :destroy ]
  before_action :set_track, only: [ :show, :update, :destroy ]
  after_action :verify_authorized, except: [ :index, :show, :create ]
  after_action :verify_policy_scoped, only: :index

  # GET /tracks
  def index
    tracks = policy_scope(Track)
    render json: tracks, each_serializer: TrackSerializer, status: :ok
  end

  # GET /tracks/:id
  def show
    authorize @track
    render json: @track, serializer: TrackSerializer, status: :ok
  end

  # POST /tracks
  def create
    @track = Track.new(track_params)
    @track.user = current_user if user_signed_in?
    authorize @track

    if @track.save
      render json: @track, serializer: TrackSerializer, status: :created
    else
      render json: { errors: @track.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tracks/:id
  def update
    authorize @track
    if @track.update(track_params)
      render json: @track, serializer: TrackSerializer, status: :ok
    else
      render json: { errors: @track.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /tracks/:id
  def destroy
    authorize @track
    @track.destroy
    head :no_content
  end

  private

  def set_track
    @track = Track.find(params[:id])
  end

  def track_params
    params.require(:track).permit(:name, :location, :length, :difficulty)
  end
end
  end
end
