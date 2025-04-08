module Api::V1
  class CarSerializer < ActiveModel::Serializer
    attributes :id, :model, :fuel_capacity
  end
end
