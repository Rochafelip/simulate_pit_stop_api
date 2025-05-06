module Api
  module V1
    class CarSerializer
      def self.call(car)
        {
          id: car.id,
          model: car.model,
          fuel_capacity: car.fuel_capacity,
          power: car.power,
          weight: car.weight,
          category: car.category,
          power_to_weight_ratio: car.power.to_f / car.weight.to_f # Exemplo de cálculo
        }
      end
    end
  end
end
