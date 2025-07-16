class CarPolicy < ApplicationPolicy
  def index?
    true # Todos podem listar
  end

  def show?
    true # Todos podem ver
  end

  def create?
    user.present?
  end

  def update?
    user.present?
  end

  def destroy?
    user.present?
  end

  def permitted_attributes
    [ :model, :power, :weight, :fuel_capacity, :category ]
  end

  # Escopo para filtrar registros
  class Scope < Scope
    def resolve
      scope.all # Mostra todas as pistas
    end
  end
end
