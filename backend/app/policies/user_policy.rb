    class UserPolicy < ApplicationPolicy
      # Qualquer usuário autenticado pode criar um usuário (ex: cadastro)
      def create?
        true
      end

      # Index só para admin (ou ajuste conforme seu requisito)
      def index?
        user.present? && user.admin?
      end

      # Mostrar usuário: só ele mesmo ou admin
      def show?
        user.present? && (record.id == user.id || user.admin?)
      end

      # Apagar usuário: só admin
      def destroy?
        user.present? && user.admin?
      end

      # Confirmação de usuário: liberado para todos (exemplo)
      def confirm_user?
        true
      end

      # Permite atributos editáveis/permitidos
      def permitted_attributes
        if user.admin?
          [:email, :name, :password, :password_confirmation, :role, :admin]
        else
          [:email, :name, :password, :password_confirmation]
        end
      end

      class Scope < Scope
        def resolve
          if user.admin?
            scope.all
          else
            # Usuários normais só veem eles mesmos
            scope.where(id: user.id)
          end
      end
    end
end
