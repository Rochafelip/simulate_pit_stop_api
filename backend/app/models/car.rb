class Car < ApplicationRecord
  has_many :races, dependent: :nullify

  # Validações de presença
  validates :model, :power, :weight, :fuel_capacity, :category, presence: { message: :blank }

  # Validações numéricas
  validates :power, numericality: {
    greater_than: 0,
    less_than_or_equal_to: 1500,
    message: :invalid_value
  }

  validates :weight, numericality: {
    only_integer: true,
    greater_than: 500,
    less_than_or_equal_to: 3000,
    message: :invalid_value
  }

  validates :fuel_capacity, numericality: {
    greater_than: 0,
    less_than_or_equal_to: 300,
    message: :invalid_value
  }

  # Validação de categoria
  validates :category, inclusion: {
    in: %w[GT3 GT4 LMP1 LMP2 LMP3 F1 Rally Rallycross Drift],
    message: :invalid_category
  }

  # Validação customizada (exemplo: relação potência/peso)
  validate :realistic_power_to_weight_ratio

  private

  def realistic_power_to_weight_ratio
    return if power.blank? || weight.blank?

    ratio = power.to_f / weight.to_f
    if ratio > 1.0 # Exemplo: 1 HP por kg é irreal para carros reais
      errors.add(:base, :unrealistic_power_to_weight_ratio)
    end
  end
end
