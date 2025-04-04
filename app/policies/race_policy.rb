class RacePolicy < ApplicationPolicy
  # Permite que o usuário veja apenas sua própria Race
  def show?
    record.user == user || user.admin?
  end

  # Permite que o usuário crie sua própria Race
  def create?
    user.present?  # O usuário precisa estar logado
  end

  # Permite que o usuário edite sua própria Race ou um admin edite qualquer Race
  def update?
    record.user == user || user.admin?
  end

  # Permite que o usuário apague sua própria Race ou um admin apague qualquer Race
  def destroy?
    record.user == user || user.admin?
  end

  # Permite que o admin veja todas as Races
  def index?
    user.admin?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(user: user) # Mostra apenas Races do usuário
    end
  end
end
