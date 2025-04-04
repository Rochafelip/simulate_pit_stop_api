class Race < ApplicationRecord
  belongs_to :car, :track, :car

  validates :name, :track, :user_id, presence: true
  validates :best_lap, :total_time, numericality: { greater_than: 0 }
end
