require 'rails_helper'

RSpec.describe User, type: :model do
  context "validações" do
    # Teste 1: Validação básica
    it "é válido com atributos obrigatórios" do
      user = build(:user)
      expect(user).to be_valid
    end

    # Teste 2: Email ausente
    it "é inválido sem email" do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include(I18n.t('errors.messages.blank'))
    end

    # Teste 3: Senha ausente
    it "é inválido sem senha" do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
    end

    # Teste 4: Confirmação de senha incorreta
    it "é inválido quando confirmação de senha não coincide" do
      user = build(:user, password_confirmation: "wrong")
      expect(user).not_to be_valid
    end

    # Teste 5: Senha curta
    it "é inválido com senha menor que 6 caracteres" do
      user = build(:user, password: "123", password_confirmation: "123")
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include(I18n.t('errors.messages.too_short', count: 6))
    end

    # Teste 6: Nome ausente
    it "é inválido sem nome" do
      user = build(:user, name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include(I18n.t('errors.messages.blank'))
    end

    # Teste 7: Email duplicado
    it "não permite email duplicado" do
      create(:user, email: "duplicado@test.com")
      user = build(:user, email: "duplicado@test.com")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include(I18n.t('errors.messages.taken'))
    end

  context "callbacks" do
    # Teste 8: Role padrão
    it "define :normal como role padrão" do
      user = create(:user, role: nil)
      expect(user.role).to eq("normal")
    end
  end
end
end
