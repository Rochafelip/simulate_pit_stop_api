require 'rails_helper'

RSpec.describe Race, type: :model do
  let(:user) { create(:user) }
  let(:car) { create(:car) }
  let(:track) { create(:track) }

  it "é válido com atributos obrigatórios" do
    race = build(:race, user: user, car: car, track: track)
    expect(race).to be_valid
  end

  it "é inválido sem usuário" do
    race = build(:race, user: nil)
    expect(race).not_to be_valid
  end

  it "é inválido com pit stops negativos" do
    race = build(:race, planned_pit_stops: -1)
    expect(race).not_to be_valid
  end

  it "pertence a um carro, pista e usuário" do
    race = create(:race, user: user, car: car, track: track)
    expect(race.car).to eq(car)
    expect(race.track).to eq(track)
    expect(race.user).to eq(user)
  end
end
