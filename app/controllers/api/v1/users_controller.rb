class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, except: [:index, :me]
  after_action :verify_policy_scoped, only: :index

  # GET /api/v1/users
  def index
    @users = policy_scope(User)
    render json: @users, each_serializer: UserSerializer, except: [:tokens, :created_at, :updated_at]
  end

  # GET /api/v1/users/me
  def me
    render json: current_user, serializer: UserProfileSerializer
  end

  # PATCH /api/v1/users/me
  def update_profile
    authorize current_user
    if current_user.update(user_profile_params)
      render json: current_user, serializer: UserProfileSerializer
    else
      render json: { errors: current_user.errors }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/users/:id (apenas admin)
  def show
    @user = User.find(params[:id])
    authorize @user
    render json: @user, serializer: UserSerializer
  end

  # DELETE /api/v1/users/:id (apenas admin)
  def destroy
    @user = User.find(params[:id])
    authorize @user
    @user.destroy
    head :no_content
  end

  private

  def user_profile_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def admin_user_params
    params.require(:user).permit(:name, :email, :role, :admin, :password, :password_confirmation)
  end

  # Override do método do Pundit para usar params diferentes
  def permitted_attributes
    current_user.admin? ? admin_user_params : user_profile_params
  end
end
