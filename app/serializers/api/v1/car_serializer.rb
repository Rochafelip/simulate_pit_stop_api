module Api
  module V1
    class CarSerializer < ActiveModel::Serializer
      attributes :id, :model, :fuel_capacity, :power, :weight, :category, :power_to_weight_ratio

      def power_to_weight_ratio
        object.power.to_f / object.weight.to_f
      end
    end
  end
end
