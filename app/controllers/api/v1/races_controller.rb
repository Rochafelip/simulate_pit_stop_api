module Api
  module V1
    class RacesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_race, only: [ :show, :update, :destroy ]
      after_action :verify_authorized

      def index
        @races = policy_scope(Race).where(user_id: current_user.id)
        authorize @races
        render json: @races, each_serializer: Api::V1::RaceSerializer
      end

      def show
        authorize @race
        render json: @race, serializer: Api::V1::RaceSerializer
      end

      def create
        @race = Race.new(race_params.merge(user_id: current_user.id))
        authorize @race

        metrics = apply_race_metrics(@race)

        if metrics[:pit_stops_sufficient] && metrics[:mandatory_pit_stop_valid] && @race.save
          render json: @race, serializer: Api::V1::RaceSerializer, status: :created
        else
          @race.errors.add(:planned_pit_stops, I18n.t("errors.activerecord.models.race.messages.insufficient_pit_stops", minimum: metrics[:minimum_pit_stops])) unless metrics[:pit_stops_sufficient]
          render json: { errors: @race.errors }, status: :unprocessable_entity
        end
      end

      def update
        authorize @race

        if @race.update(race_params)
          metrics = apply_race_metrics(@race)

          if metrics[:pit_stops_sufficient] && metrics[:mandatory_pit_stop_valid] && @race.save
            render json: @race, serializer: Api::V1::RaceSerializer
          else
            @race.errors.add(:planned_pit_stops, I18n.t(
              "errors.activerecord.models.race.messages.insufficient_pit_stops",
              minimum: metrics[:minimum_pit_stops]
            ))
            render json: { errors: @race.errors }, status: :unprocessable_entity
          end
        else
          render json: { errors: @race.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @race
        @race.destroy
        head :no_content
      end

      private

      def set_race
        @race = Race.find_by(id: params[:id])
        render json: { error: "Race not found" }, status: :not_found unless @race
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
