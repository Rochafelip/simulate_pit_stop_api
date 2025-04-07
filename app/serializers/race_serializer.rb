# app/serializers/race_serializer.rb
class RaceSerializer < ActiveModel::Serializer
  attributes :id, :total_laps, :fuel_consumption_per_lap, :average_lap_time, :total_fuel_needed

  belongs_to :car
  belongs_to :track
  belongs_to :user

  def total_fuel_needed
    # Exemplo de como calcular o combustível necessário
    object.total_laps * object.fuel_consumption_per_lap
  end
end
