class Race < ApplicationRecord
  # Associações (garanta que car e track sejam obrigatórios)
  belongs_to :user
  belongs_to :car, required: true
  belongs_to :track, required: true

  # Callbacks
  before_validation :set_denormalized_fields
  before_validation :calculate_total_fuel_needed

  # Validações básicas
  validates :total_laps, numericality: {
    greater_than: 0,
    message: "deve ser maior que zero"
  }

  validates :average_lap_time, numericality: {
    greater_than: 0,
    message: "deve ser maior que zero"
  }

  # Validações condicionais
  validates :race_time_minutes, numericality: {
    greater_than: 0,
    allow_nil: true,
    message: "deve ser maior que zero"
  }

  validates :planned_pit_stops, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    allow_nil: true,
    message: "deve ser um número inteiro não negativo"
  }

  private

  # Desnormalização de dados
  def set_denormalized_fields
    self.car_name = car.model
    self.car_category = car.category
    self.track_name = track.name
  end

  # Cálculo automático de combustível
  def calculate_total_fuel_needed
    self.total_fuel_needed = fuel_consumption_per_lap * total_laps
  end
end
