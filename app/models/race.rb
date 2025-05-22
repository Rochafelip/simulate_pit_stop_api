class Race < ApplicationRecord
  belongs_to :user
  belongs_to :car
  belongs_to :track

  # Callbacks
  before_save :set_denormalized_fields

  # Validações básicas
  validates :total_laps, numericality: {
    greater_than: 0,
    message: :must_be_greater_than_zero
  }

  validates :average_lap_time, numericality: {
    greater_than: 0,
    message: :must_be_greater_than_zero
  }

  # Validações condicionais
  validates :race_time_minutes, numericality: {
    greater_than: 0,
    allow_nil: true,
    message: :must_be_greater_than_zero
  }

  validates :planned_pit_stops, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    allow_nil: true,
    message: :must_be_non_negative_integer
  }

  private

  def set_denormalized_fields
    return unless car && track

    self.car_name = car.model
    self.car_category = car.category
    self.track_name = track.name
  end
end
