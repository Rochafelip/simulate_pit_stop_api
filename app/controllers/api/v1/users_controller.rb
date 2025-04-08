class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, except: [:index, :me]
  after_action :verify_policy_scoped, only: :index


  # POST /api/v1/users (Criar um novo usuário, sem autenticação)
  def create
    @user = User.new(user_profile_params)
    if @user.save
      render json: @user, status: :created, serializer: UserProfileSerializer
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/users (Listar usuários, apenas admin pode listar todos)
  def index
    @users = policy_scope(User)  # Verifica a política de escopo
    render json: @users, each_serializer: UserSerializer, except: [:tokens, :created_at, :updated_at]
  end

  # GET /api/v1/users/:id (Mostrar detalhes de um usuário, apenas admin pode acessar)
  def show
    @user = User.find(params[:id])
    authorize @user  # Autoriza o acesso, apenas admin pode ver outro usuário
    render json: @user, serializer: UserSerializer
  end

  # GET /api/v1/users/me
  def me
    render json: current_user, serializer: UserSerializer
  end

  # PATCH /api/v1/users/me
  def update_profile
    # Adicionando a autorização aqui, para garantir que o usuário está autorizado a atualizar seu próprio perfil
    authorize current_user

    if current_user.update(user_profile_params)
      render json: current_user, serializer: UserProfileSerializer
    else
      render json: { errors: current_user.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/users/:id (Excluir usuário, apenas admin pode excluir)
  def destroy
    @user = User.find(params[:id])
    authorize @user  # Autoriza a exclusão, apenas admin pode excluir
    @user.destroy
    head :no_content
  end

  private

  def user_profile_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # Override para verificar se é admin e permitir parâmetros adicionais
  def permitted_attributes
    current_user.admin? ? admin_user_params : user_profile_params
  end
end
