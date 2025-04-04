class Race < ApplicationRecord
  belongs_to :car
  belongs_to :track
end
