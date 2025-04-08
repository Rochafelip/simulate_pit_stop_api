class CarSerializer < ActiveModel::Serializer
  attributes :id, :model, :fuel_capacity
end
