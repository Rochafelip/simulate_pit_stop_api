# app/serializers/user_serializer.rb
class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :created_at, :updated_at

  # Relacionamentos, caso existam, podem ser definidos aqui
  # has_many :races
  # has_many :cars

  def created_at
    object.created_at.strftime('%d/%m/%Y %H:%M')
  end

  def updated_at
    object.updated_at.strftime('%d/%m/%Y %H:%M')
  end
end
