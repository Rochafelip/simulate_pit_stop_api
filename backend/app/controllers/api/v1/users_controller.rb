module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!, only: %i[index show destroy]
      before_action :set_user, only: %i[show destroy]
      after_action :verify_authorized, except: %i[index]
      after_action :verify_policy_scoped, only: :index

      # POST /api/v1/users
      def create
        @user = User.new(permitted_attributes(User))
        authorize @user

        if @user.save
          render json: UserSerializer.call(@user), status: :created
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # GET /api/v1/users
      def index
        users = policy_scope(User)
        render json: users.map { |user| UserSerializer.call(user) }, status: :ok
      end

      # GET /api/v1/users/:id
      def show
        authorize @user
        render json: UserSerializer.call(@user), status: :ok
      end

      # POST /api/v1/confirm_user
      def confirm_user
        user = User.find_by(email: params[:email])

        unless user
          render json: { error: 'Usuário não encontrado.' }, status: :not_found and return
        end

        if user.confirmed?
          render json: { message: 'Usuário já confirmado.' }, status: :ok and return
        end

        if user.confirm
          render json: { message: 'Usuário confirmado com sucesso.' }, status: :ok
        else
          render json: { error: 'Não foi possível confirmar o usuário.' }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/users/:id
      def destroy
        authorize @user
        @user.destroy
        head :no_content
      end

      private

      def set_user
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Usuário não encontrado.' }, status: :not_found
      end
    end
  end
end
