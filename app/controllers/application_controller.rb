class ApplicationController < ActionController::API
        include DeviseTokenAuth::Concerns::SetUserByToken
        include Pundit::Authorization

        rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

        private

        def user_not_authorized
                render json: { error: "Você não tem permissão para esta ação" }, status: :forbidden
        end
end
