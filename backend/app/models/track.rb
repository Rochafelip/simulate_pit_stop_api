class Track < ApplicationRecord
 VALID_COUNTRIES = ISO3166::Country.all.map { |country| country.translations['en'] } + ["Monaco"]

  has_many :races, dependent: :nullify

  validates :name, :distance, :number_of_curves, :country, :elevation_track, presence: { message: :blank }

  validates :distance, numericality: {
    greater_than_or_equal_to: 1.0,
    less_than_or_equal_to: 25.0,
    message: :invalid_value
  }

  validates :number_of_curves, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 180,
    message: :invalid_value
  }

  validates :elevation_track, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 350,
    message: :invalid_value
  }

  validates :name, uniqueness: { case_sensitive: false, message: :duplicate_name }
end
