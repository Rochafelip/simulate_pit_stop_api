class TrackPolicy < ApplicationPolicy
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
    user.present? # Qualquer user autenticado pode editar
  end

  def destroy?
    user.admin? # Apenas admins podem deletar
  end

  def permitted_attributes
    [:name, :country, :distance, :number_of_curves, :elevation_track]
  end
  # Escopo para filtrar registros
  class Scope < Scope
    def resolve
      scope.all # Mostra todas as pistas
    end
  end
end
