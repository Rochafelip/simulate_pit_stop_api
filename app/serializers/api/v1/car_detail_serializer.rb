module Api
  module V1
  class CarDetailSerializer < ActiveModel::Serializer
      attributes :id, :model, :power, :weight, :fuel_capacity, :category, :created_at, :updated_at

      # Se desejar formatar as datas de forma personalizada, pode fazer algo assim:
      def created_at
        object.created_at.strftime("%d/%m/%Y %H:%M")
      end

      def updated_at
        object.updated_at.strftime("%d/%m/%Y %H:%M")
      end
  end
  end
end
