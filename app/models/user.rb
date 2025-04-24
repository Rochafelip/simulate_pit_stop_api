class User < ApplicationRecord
  include DeviseTokenAuth::Concerns::User

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :races, dependent: :destroy

  # Devise e Devise Token Auth aqui
  enum :role, { normal: 0, admin: 1 }
  validates :name, presence: true

  # Método para verificar se o usuário é admin
  def admin?
    self.admin
  end
end
