class Track < ApplicationRecord
    VALID_COUNTRIES = ISO3166::Country.all.map { |country| country.translations['en'] } + ["Monaco"]
    has_many :races, dependent: :nullify
    # Validações de presença
    validates :name, :distance, :number_of_curves, :country, :elevation_track, presence: true

    # Validações numéricas
    validates :distance, numericality: {
      greater_than: 1.0, # Mínimo 1 km
      less_than_or_equal_to: 25.0 # Circuito mais longo (Nürburgring Nordschleife + GP = 25.378 km)
    }

    validates :number_of_curves, numericality: {
      only_integer: true,
      greater_than: 0,
      less_than_or_equal_to: 50
    }

    validates :elevation_track, numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 300 # Bathurst tem ~174m, limite seguro para 300m
    }

    # Validação de país (lista de países reconhecidos)
    validates :country, inclusion: {
        in: VALID_COUNTRIES,
        message: "%{value} não é um país válido"
      }

    # Validação customizada: nome deve ser único considerando maiúsculas/minúsculas
    validates :name, uniqueness: { case_sensitive: false }
end
