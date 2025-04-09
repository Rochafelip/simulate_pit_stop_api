module Api
  module V1
  class RacesController < ApplicationController
    before_action :authenticate_user!
    after_action :verify_authorized, except: [ :index, :show ]
    after_action :verify_policy_scoped, only: :index

    # GET /api/v1/races
    def index
      races = policy_scope(Race)
      render json: races, each_serializer: Api::V1::RaceSerializer, status: :ok
    end

    # GET /api/v1/races/:id
    def show
      @race = find_race
      authorize @race
      render json: @race, serializer: Api::V1::RaceSerializer, status: :ok
    end

    # POST /api/v1/races
    def create
      @race = Race.new(race_params.merge(user_id: current_user.id))
      authorize @race

      car = Car.find_by(id: race_params[:car_id])
      track = Track.find_by(id: race_params[:track_id])

      if car.nil? || track.nil?
        return render json: { errors: "Carro ou pista não encontrados" }, status: :unprocessable_entity
      end

      @race.car = car
      @race.track = track

      calculator = RaceCalculator.new(car, @race)
      @race.total_fuel_needed = calculator.total_fuel_needed

      if calculator.pit_stops_sufficient? && calculator.validate_mandatory_pit_stops(@race)
        if @race.save
          render json: @race, serializer: Api::V1::RaceSerializer, status: :created
        else
          render json: { errors: @race.errors.full_messages }, status: :unprocessable_entity
        end
      else
        @race.errors.add(:planned_pit_stops, "Pit stops insuficientes (mínimo: #{calculator.minimum_pit_stops})")
        render json: { errors: @race.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # PATCH /api/v1/races/:id
    def update
      @race = find_race
      authorize @race

      if @race.update(race_params)
        render json: @race, serializer: Api::V1::RaceSerializer, status: :ok
      else
        render json: { errors: @race.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/races/:id
    def destroy
      @race = find_race
      authorize @race
      @race.destroy
      head :no_content
    end

    private

    def race_params
      params.require(:race).permit(
        :car_id,
        :track_id,
        :total_laps,
        :fuel_consumption_per_lap,
        :average_lap_time,
        :race_time_minutes,
        :mandatory_pit_stop,
        :planned_pit_stops
      )
    end

    def find_race
      Race.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render_not_found("Race not found")
    end

    def render_not_found(message)
      render json: { error: message }, status: :not_found
    end
  end
  end
end
