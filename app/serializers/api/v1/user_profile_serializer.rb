module Api
  module V1
  class UserProfileSerializer < ActiveModel::Serializer
      attributes :id, :name, :email, :role, :created_at, :updated_at

    # Pode adicionar mais informações específicas do perfil aqui
    # Exemplo: has_one :profile
  end
  end
end
