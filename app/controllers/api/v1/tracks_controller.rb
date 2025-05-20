module Api
  module V1
    class TracksController < ApplicationController
      before_action :authenticate_user!, only: [ :create, :update, :destroy ]
      before_action :set_track, only: [ :show, :update, :destroy ]
      after_action :verify_authorized, except: :index
      after_action :verify_policy_scoped, only: :index

      # GET /tracks
      def index
        tracks = policy_scope(Track)
        render json: tracks, each_serializer: Api::V1::TrackSerializer, status: :ok
      end

      # GET /tracks/:id
      def show
        authorize @track
        render json: @track, serializer: Api::V1::TrackSerializer, status: :ok
      end

        # POST /tracks
        def create
        @track = Track.new(permitted_attributes(Track))
        authorize @track

        if @track.save
          render json: @track, serializer: Api::V1::TrackSerializer, status: :created
        else
          render json: { errors: @track.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /tracks/:id
      def update
        authorize @track
        if @track.update(permitted_attributes(Track))
          render json: @track, serializer: Api::V1::TrackSerializer, status: :ok
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
        params.require(:track).permit(:id, :name, :country, :distance, :number_of_curves, :elevation_track, :created_at, :updated_at)
      end
    end
  end
end
