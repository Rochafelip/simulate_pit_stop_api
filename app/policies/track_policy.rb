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
    create?
  end

  def destroy?
    update? # Mesma regra de update
  end

  def permitted_attributes
    [ :id, :name, :country, :distance, :number_of_curves, :elevation_track, :created_at, :updated_at ]
  end
  # Escopo para filtrar registros
  class Scope < Scope
    def resolve
      scope.all # Mostra todas as pistas
    end
  end
end
