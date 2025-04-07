class TrackPolicy < ApplicationPolicy
  def index?
    true # Todos podem listar
  end

  def show?
    true # Todos podem ver
  end

  def create?
    user.present? # Apenas usuários logados
  end

  def update?
    record.user == user # Apenas dono do carro
  end

  def destroy?
    update? # Mesma regra de update
  end

  # Escopo para filtrar registros
  class Scope < Scope
    def resolve
      scope.all # Mostra todas as pistas
    end
  end
end
