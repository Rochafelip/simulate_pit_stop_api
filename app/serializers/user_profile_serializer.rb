# app/serializers/user_profile_serializer.rb
class UserProfileSerializer < ActiveModel::Serializer
    attributes :id, :name, :email, :role, :created_at, :updated_at

  # Pode adicionar mais informações específicas do perfil aqui
  # Exemplo: has_one :profile
end
