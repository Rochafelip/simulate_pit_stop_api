# app/serializers/api/v1/race_serializer.rb
module Api::V1
  class RaceSerializer < ActiveModel::Serializer
    attributes :id,
               :car_name,
               :car_category,
               :track_name,
               :race_time_minutes,
               :mandatory_pit_stop,
               :planned_pit_stops,
               :average_lap_time,
               :fuel_consumption_per_lap,
               :total_laps,
               :total_fuel_needed,
               :fuel_per_pit_stop,  # Novo campo calculado
               :estimated_pit_time  # Novo campo calculado

    # Combustível por pit stop (calculado)
    def fuel_per_pit_stop
      return 0 if object.planned_pit_stops.zero?
      object.total_fuel_needed / (object.planned_pit_stops + 1)
    end

    # Tempo estimado gasto em pit stops (30s por parada)
    def estimated_pit_time
      object.planned_pit_stops * 30 # segundos
    end
  end
end
