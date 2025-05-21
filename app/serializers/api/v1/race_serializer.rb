# app/serializers/api/v1/race_serializer.rb
module Api
  module V1
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
                 :total_fuel_needed
    end
  end
end
