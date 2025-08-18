class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Pundit::Authorization
  include ActionController::Cookies

  before_action :configure_permitted_parameters, if: :devise_controller?

  after_action :verify_authorized, unless: :devise_controller?
  after_action :verify_policy_scoped, only: :index


  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def current_user
    current_api_v1_user
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  private

  def devise_controller?
    is_a?(DeviseController) || self.class.name.start_with?("DeviseTokenAuth::")
  end

  def user_not_authorized
    render json: { error: 'Você não tem permissão para executar esta ação.' }, status: :forbidden
  end

  def record_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end
end
