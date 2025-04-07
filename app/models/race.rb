class Race < ApplicationRecord
  belongs_to :user
  belongs_to :track
  has_many :cars

  validates :car, :track, :user, presence: true
  validates :total_laps, numericality: { only_integer: true, greater_than: 0 }
  validates :fuel_consumption_per_lap, :average_lap_time, :total_fuel_needed, numericality: { greater_than_or_equal_to: 0 }
end
