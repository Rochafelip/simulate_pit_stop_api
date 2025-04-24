require 'rails_helper'

RSpec.describe User, type: :model do
  it "é válido com email, senha, confirmação de senha e nome" do
    user = User.new(email: "AnaCarol@email.com", password: "password123", password_confirmation: "password123", name: "Ana Dantas")

    expect(user).to be_valid
  end

  it "é inválido sem email" do
    user = User.new(email: nil, password: "password123", password_confirmation: "password123",
      name: "Ana Dantas"
    )

    expect(user).not_to be_valid
  end

  it "é inválido sem senha" do
    user = User.new(email: "test@email.com", name: "Test User", password_confirmation: "password123")
    expect(user).not_to be_valid
  end

  it "é inválido confirmação de senha está errado" do
    user = User.new(email: "test@email.com", name: "Test User", password: "password123", password_confirmation: "outrasenha")
    expect(user).not_to be_valid
  end

  it "é inválido com senha muito curta" do
    user = User.new(email: "test@email.com", password: "123", password_confirmation: "123", name: "User")
    expect(user).not_to be_valid
  end

  it "é inválido sem nome" do
    user = User.new(email: "test@email.com", password: "password123", password_confirmation: "password123")
    expect(user).not_to be_valid
  end

  it "não permite email duplicado" do
    User.create!(email: "duplicado@email.com", password: "123456", password_confirmation: "123456", name: "Fulano")
    user = User.new(email: "duplicado@email.com", password: "123456", password_confirmation: "123456", name: "Beltrano")
    expect(user).not_to be_valid
  end

  it "define o role padrão como normal" do
    user = User.new(email: "test@email.com", password: "123456", password_confirmation: "123456", name: "User")
    user.save
    expect(user.role).to eq("normal")
  end
end
