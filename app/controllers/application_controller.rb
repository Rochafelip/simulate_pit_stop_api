class ApplicationController < ActionController::API
        include DeviseTokenAuth::Concerns::SetUserByToken
        include Pundit::Authorization

        before_action :configure_permitted_parameters, if: :devise_controller?

        rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

        protected

        def configure_permitted_parameters
          devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
          devise_parameter_sanitizer.permit(:account_update, keys: [ :name ])
        end

        private

        def user_not_authorized
          render json: { error: "Você não tem permissão para executar esta ação." }, status: :forbidden
        end
end
