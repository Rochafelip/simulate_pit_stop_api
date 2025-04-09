module Api
  module V1
  class CarSerializer < ActiveModel::Serializer
    attributes :id, :model, :fuel_capacity
  end
  end
end
