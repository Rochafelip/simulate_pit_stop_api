module Api
  module V1
class UsersController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, except: [ :index, :me ]
  after_action :verify_policy_scoped, only: :index

  # POST /api/v1/users
  def create
    @user = User.new(user_profile_params)

    if @user.save
      render json: @user, status: :created, serializer: UserProfileSerializer
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/users
  def index
    users = policy_scope(User)
    render json: users, each_serializer: UserSerializer, except: [ :tokens, :created_at, :updated_at ], status: :ok
  end

  # GET /api/v1/users/:id
  def show
    @user = User.find(params[:id])
    authorize @user
    render json: @user, serializer: UserSerializer, status: :ok
  end

  # GET /api/v1/users/me
  def me
    render json: current_user, serializer: UserSerializer, status: :ok
  end

  # PATCH /api/v1/users/me
  def update_profile
    authorize current_user

    if current_user.update(user_profile_params)
      render json: current_user, serializer: UserProfileSerializer, status: :ok
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/users/:id
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
end
  end
end
