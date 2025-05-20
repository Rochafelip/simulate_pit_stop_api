module Api
  module V1
    class RacesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_race, only: [:show, :destroy]
      after_action :verify_authorized

      def index
        @races = current_user.races
        authorize @races
        render json: @races, each_serializer: Api::V1::RaceSerializer
      end

      def show
        authorize @race
        render json: @race, serializer: Api::V1::RaceSerializer
      end

      def create
        @race = current_user.races.new(race_params)
        authorize @race

        return render_not_found unless car_and_track_present?

        assign_car_and_track_data
        calculate_fuel

        if pit_stops_valid?
          if @race.save
            render json: @race, serializer: Api::V1::RaceSerializer, status: :created
          else
            render json: { errors: @race.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: { errors: @race.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @race
        @race.destroy
        head :no_content
      end

      private

      def race_params
        params.require(:race).permit(
          :car_id, :track_id, :total_laps,
          :fuel_consumption_per_lap, :average_lap_time,
          :mandatory_pit_stop, :planned_pit_stops, :race_time_minutes
        )
      end

      def set_race
        @race = Race.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: I18n.t("race.errors.not_found") }, status: :not_found
      end

      def car_and_track_present?
        @race.car.present? && @race.track.present?
      end

      def render_not_found
        render json: { errors: I18n.t("race.attributes.car_or_track_not_found") }, status: :unprocessable_entity
      end

      def assign_car_and_track_data
        @race.car_name = @race.car.model
        @race.car_category = @race.car.category
        @race.track_name = @race.track.name
      end

      def calculate_fuel
        calculator = RaceCalculator.new(@race.car, @race)
        @race.total_fuel_needed = calculator.total_fuel_needed
        @pit_stop_validator = calculator
      end

      def pit_stops_valid?
        if @pit_stop_validator.pit_stops_sufficient? &&
           @pit_stop_validator.validate_mandatory_pit_stops(@race)
          true
        else
          @race.errors.add(:planned_pit_stops, I18n.t("races.errors.insufficient_pit_stops", count: @pit_stop_validator.minimum_pit_stops))
          false
        end
      end
    end
  end
end
