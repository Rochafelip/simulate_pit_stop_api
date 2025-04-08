module Api::V1
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :name, :email, :created_at, :updated_at

    def created_at
      object.created_at.strftime('%d/%m/%Y %H:%M')
    end

    def updated_at
      object.updated_at.strftime('%d/%m/%Y %H:%M')
    end
  end
end
