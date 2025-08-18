module Api
  module V1
    class TracksController < ApplicationController
      before_action :authenticate_api_v1_user!, only: %i[create update destroy]
      before_action :set_track, only: %i[show update destroy]
      before_action :ensure_json_request

      after_action :verify_authorized, except: :index
      after_action :verify_policy_scoped, only: :index

      # GET /api/v1/tracks
      def index
        tracks = policy_scope(Track)
        render json: tracks, each_serializer: Api::V1::TrackSerializer, status: :ok
      end

      # GET /api/v1/tracks/:id
      def show
        authorize @track
        render json: @track, serializer: Api::V1::TrackSerializer, status: :ok
      end

      # POST /api/v1/tracks
      def create
        @track = Track.new(permitted_attributes(Track))
        authorize @track

        if @track.save
          render json: @track, serializer: Api::V1::TrackSerializer, status: :created
        else
          render json: { errors: @track.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PUT/PATCH /api/v1/tracks/:id
      def update
        authorize @track

        if @track.update(permitted_attributes(@track))
          render json: @track, serializer: Api::V1::TrackSerializer, status: :ok
        else
          render json: { errors: @track.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/tracks/:id
      def destroy
        authorize @track
        @track.destroy
        head :no_content
      end

      private

      def ensure_json_request
        return if request.format.json?

        render body: nil, status: :not_acceptable
      end

      def set_track
        @track = Track.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Pista não encontrada' }, status: :not_found
      end
    end
  end
end
