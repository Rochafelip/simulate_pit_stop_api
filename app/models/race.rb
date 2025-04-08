class Race < ApplicationRecord
  belongs_to :user
  belongs_to :car
  belongs_to :track

  validates :car_name, :car_category, :track_name, presence: true
  validates :race_time_minutes, numericality: { greater_than: 0 }, allow_nil: true
  validates :planned_pit_stops, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
end
