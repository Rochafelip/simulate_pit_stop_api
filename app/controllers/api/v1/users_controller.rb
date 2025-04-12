module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!, only: [ :index, :show, :destroy, :update_profile ]

      after_action :verify_authorized, except: [ :index, :me, :create ]
      after_action :verify_policy_scoped, only: :index

      # POST /api/v1/users
      def create
        @user = User.new(sign_up_params)
        authorize @user

        if @user.save
          render json: {
            message: I18n.t("users.create.success"),
            user: ActiveModelSerializers::SerializableResource.new(@user, serializer: UserSerializer).as_json
          }, status: :created
        else
          render json: {
            errors: @user.errors.full_messages,
            message: I18n.t("users.create.failure")
          }, status: :unprocessable_entity
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
          render json: { message: I18n.t("users.update_profile.success"), user: current_user }, status: :ok, serializer: UserProfileSerializer
        else
          render json: { errors: current_user.errors.full_messages, message: I18n.t("users.update_profile.failure") }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/users/:id
      def destroy
        @user = User.find(params[:id])
        authorize @user
        @user.destroy
        render json: { message: I18n.t("users.destroy.success") }, status: :no_content
      end

      private

      def sign_up_params
        # Adicione todos os campos necessários para o registro
        params.require(:user).permit(
          :email,
          :password,
          :password_confirmation,
          :name,
          :confirm_success_url  # Mantenha se for usado pelo Devise Token Auth
        )
      end

      def user_profile_params
        params.require(:user).permit(:name, :email)  # Exemplo para atualização
      end
    end
  end
end
