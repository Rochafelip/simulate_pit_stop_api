# app/serializers/race_serializer.rb
class RaceSerializer < ActiveModel::Serializer
  attributes :id, :car_name, :car_category, :track_name, :race_time_minutes,
             :mandatory_pit_stop, :planned_pit_stops, :average_lap_time,
             :fuel_consumption_per_lap, :total_laps, :total_fuel_needed

  belongs_to :user
  belongs_to :car
  belongs_to :track

  def total_fuel_needed
    # Exemplo de como calcular o combustível necessário
    object.total_laps * object.fuel_consumption_per_lap
  end
end
