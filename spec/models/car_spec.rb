require 'rails_helper'

RSpec.describe Car, type: :model do
  it "é válido com todos os atributos obrigatórios corretamente preenchidos" do
    car = build(:car)
    expect(car).to be_valid
  end

  it "é inválido sem modelo" do
    car = build(:car, model: nil)
    expect(car).not_to be_valid
  end

  it "é inválido com potência maior que 1500" do
    car = build(:car, power: 1600)
    expect(car).not_to be_valid
  end

  it "é inválido com peso menor que 500" do
    car = build(:car, weight: 400)
    expect(car).not_to be_valid
  end

  it "é inválido com capacidade de combustível maior que 300" do
    car = build(:car, fuel_capacity: 350)
    expect(car).not_to be_valid
  end

  it "é inválido com categoria fora da lista permitida" do
    car = build(:car, category: "Kart")
    expect(car).not_to be_valid
  end

  it "é inválido se a razão potência/peso for irreal" do
    car = build(:car, power: 1500, weight: 1000) # razão = 1.5
    expect(car).not_to be_valid
  end
end
