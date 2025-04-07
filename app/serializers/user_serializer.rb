# app/serializers/user_serializer.rb
class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :role, :created_at, :updated_at

  # Relacionamentos, caso existam, podem ser definidos aqui
  # has_many :races
  # has_many :cars
end
