module Api
  module V1
    class RacesController < ApplicationController
      before_action :authenticate_api_v1_user!        # Só usuário logado acessa qualquer ação
      before_action :set_race, only: %i[show update destroy]
      before_action :ensure_json_request

      after_action :verify_authorized, except: :index
      after_action :verify_policy_scoped, only: :index

      # GET /api/v1/races
      def index
        races = policy_scope(Race).includes(:car, :track)
        render json: races, each_serializer: Api::V1::RaceSerializer, status: :ok
      end

      # GET /api/v1/races/:id
      def show
        authorize @race
        render json: @race, serializer: Api::V1::RaceSerializer, status: :ok
      end

      # POST /api/v1/races
      def create
        @race = Race.new(race_params.merge(user_id: current_user.id))
        authorize @race

        metrics = apply_race_metrics(@race)

        if metrics[:pit_stops_sufficient] && metrics[:mandatory_pit_stop_valid] && @race.save
          render json: @race, serializer: Api::V1::RaceSerializer, status: :created
        else
          @race.errors.add(:planned_pit_stops, I18n.t("errors.activerecord.models.race.messages.insufficient_pit_stops", minimum: metrics[:minimum_pit_stops])) unless metrics[:pit_stops_sufficient]
          render json: { errors: @race.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PUT/PATCH /api/v1/races/:id
      def update
        authorize @race

        if @race.update(race_params)
          metrics = apply_race_metrics(@race)

          if metrics[:pit_stops_sufficient] && metrics[:mandatory_pit_stop_valid]
            render json: @race, serializer: Api::V1::RaceSerializer, status: :ok
          else
            @race.errors.add(:planned_pit_stops, I18n.t("errors.activerecord.models.race.messages.insufficient_pit_stops", minimum: metrics[:minimum_pit_stops])) unless metrics[:pit_stops_sufficient]
            render json: { errors: @race.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: { errors: @race.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/races/:id
      def destroy
        authorize @race
        @race.destroy
        head :no_content
      end

      private

      def ensure_json_request
        return if request.format.json?

        render body: nil, status: :not_acceptable
      end

      def set_race
        @race = Race.find_by(id: params[:id])
        return if @race

        render json: { error: 'Corrida não encontrada' }, status: :not_found
      end

      def apply_race_metrics(race)
        metrics = RaceMetricsService.new(race).compute_all_metrics
        race.total_fuel_needed = metrics[:total_fuel_needed]
        metrics
      end

      def race_params
        params.require(:race).permit(
          :car_id, :track_id, :total_laps, :fuel_consumption_per_lap,
          :average_lap_time, :race_time_minutes,
          :mandatory_pit_stop, :planned_pit_stops
        )
      end
    end
  end
end
