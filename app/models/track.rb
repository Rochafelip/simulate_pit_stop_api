class Track < ApplicationRecord
  VALID_COUNTRIES = ISO3166::Country.all.map { |country| country.translations['en'] } + ["Monaco"]
  has_many :races, dependent: :nullify

  # Validações de presença
  validates :name, :distance, :number_of_curves, :country, :elevation_track, presence: { message: :blank }

  # Validações numéricas
  validates :distance, numericality: {
    greater_than: 1.0,
    less_than_or_equal_to: 25.0,
    message: :invalid_value
  }

  validates :number_of_curves, numericality: {
    only_integer: true,
    greater_than: 0,
    less_than_or_equal_to: 50,
    message: :invalid_value
  }

  validates :elevation_track, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 300,
    message: :invalid_value
  }

  # Validação customizada: nome deve ser único considerando maiúsculas/minúsculas
  validates :name, uniqueness: { case_sensitive: false, message: :duplicate_name }
end
