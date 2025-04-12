class UserPolicy < ApplicationPolicy
  # Permite que qualquer um crie um usuário (registro público)
  def create?
    true
  end

  # Listagem de usuários (só admin)
  def index?
    user.admin?
  end

  # Visualizar perfil (só admin ou o próprio usuário)
  def show?
    user.admin? || record == user
  end

  # Ver próprio perfil
  def me?
    true
  end

  # Atualizar perfil (apenas o próprio usuário)
  def update_profile?
    record == user
  end

  # Deletar usuário (só admin, e não pode se autodeletar)
  def destroy?
    user.admin? && user != record
  end

  class Scope < Scope
    # Escopo: admin vê todos, outros não veem ninguém
    def resolve
      if user.admin?
        scope.all
      else
        scope.none
      end
    end
  end
end
