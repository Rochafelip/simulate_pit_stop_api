class UserPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def show?
    user.admin?
  end

  def me?
    true # Todos podem ver seu próprio perfil
  end

  def update_profile?
    record == user # Só pode atualizar a si mesmo
  end

  def destroy?
    user.admin? && user != record # Admin não pode se deletar
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.none # Usuários normais não veem outros
      end
    end
  end
end
