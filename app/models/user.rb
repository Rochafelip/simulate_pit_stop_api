class User < ApplicationRecord
  include DeviseTokenAuth::Concerns::User

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :races, dependent: :destroy

  # Devise e Devise Token Auth aqui
  enum :role, { normal: 0, admin: 1 }
 # Validações com i18n
 validates :name, presence: { message: :blank }
 validates :email, presence: { message: :blank },
                   uniqueness: { message: :taken },
                   format: { with: URI::MailTo::EMAIL_REGEXP, message: :invalid }

  validates :password,
  length: {
    minimum: 6,
    too_short: "é muito curto (mínimo: 6 caracteres)"
  },
  allow_nil: true

  # Callback para definir role padrão
  before_validation :set_default_role

  # Método para verificar se o usuário é admin
  def admin?
    admin
  end

  private

  def set_default_role
    self.role ||= :normal
  end
end
