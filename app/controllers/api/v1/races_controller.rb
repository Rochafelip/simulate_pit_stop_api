module Api::V1
  class RacesController < ApplicationController
    before_action :authenticate_user!
    after_action :verify_authorized, except: [ :index, :show ]
    after_action :verify_policy_scoped, only: :index

    def index
      @races = policy_scope(Race)
      render json: @races, each_serializer: Api::V1::RaceSerializer
    end

    def show
      @race = Race.find(params[:id])
      authorize @race
      render json: @races, each_serializer: Api::V1::RaceSerializer
    end

    def create
      # Cria a corrida primeiro (para autorização)
      @race = Race.new(race_params.merge(user_id: current_user.id))
      authorize @race

      # Busca car e track
      car = Car.find_by(id: race_params[:car_id])
      track = Track.find_by(id: race_params[:track_id])

      # Atribui car e track à corrida (ou adiciona erros)
      if car && track
        @race.car = car
        @race.track = track
      else
        @race.errors.add(:base, "Carro ou pista não encontrados")
        return render json: { errors: @race.errors.full_messages }, status: :unprocessable_entity
      end

      # Cálculos e validações
      calculator = RaceCalculator.new(car, @race)
      @race.total_fuel_needed = calculator.total_fuel_needed

      unless calculator.pit_stops_sufficient?
        @race.errors.add(:planned_pit_stops, "Pit stops insuficientes (mínimo: #{calculator.minimum_pit_stops})")
      end

      calculator.validate_mandatory_pit_stops(@race)

      if @race.save
        render json: @races, each_serializer: Api::V1::RaceSerializer, status: :created
      else
        render json: { errors: @race.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      @race = Race.find(params[:id])
      authorize @race

      if @race.update(race_params)
        render json: @races, each_serializer: Api::V1::RaceSerializer
      else
        render json: { errors: @race.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @race = Race.find(params[:id])
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

    def render_not_found(message)
      render json: { error: message }, status: :not_found
    end
  end
end
