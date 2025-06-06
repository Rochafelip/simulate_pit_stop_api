module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!, only: %i[index show destroy update_profile]
      before_action :set_user, only: %i[show destroy]
      after_action :verify_authorized, except: %i[index me]
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

      # GET /api/v1/users/me
      def me
        render json: UserSerializer.call(current_user), status: :ok
      end

      # PATCH /api/v1/users/me
      def update_profile
        authorize current_user
        if current_user.update(permitted_attributes(current_user))
          render json: {
            message: I18n.t("users.update_profile.success"),
            user: UserSerializer.call(current_user)
          }, status: :ok
        else
          render json: {
            message: I18n.t("users.update_profile.failure"),
            errors: current_user.errors.full_messages
          }, status: :unprocessable_entity
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
        render json: { error: "User not found" }, status: :not_found
      end
    end
  end
end
