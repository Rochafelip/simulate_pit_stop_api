module Api
  module V1
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :name, :email, :created_at

    def created_at
      object.created_at.strftime("%d/%m/%Y %H:%M")
    end
  end
  end
end
