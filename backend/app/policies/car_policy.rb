class CarPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.present?
  end

  def update?
    user.present?
  end

  def destroy?
    user.admin?
  end

  def permitted_attributes
    [ :model, :power, :weight, :fuel_capacity, :category ]
  end

  # Escopo para filtrar registros
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
