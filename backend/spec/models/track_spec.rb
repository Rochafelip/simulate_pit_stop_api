require 'rails_helper'

RSpec.describe Track, type: :model do
  it "é válido com todos os atributos obrigatórios corretamente preenchidos" do
    track = build(:track)
    expect(track).to be_valid
  end

  it "é inválido sem nome" do
    track = build(:track, name: nil)
    expect(track).not_to be_valid
  end

  it "é inválido sem distância" do
    track = build(:track, distance: nil)
    expect(track).not_to be_valid
  end

  it "é inválido sem número de curvas" do
    track = build(:track, number_of_curves: nil)
    expect(track).not_to be_valid
  end

  it "é inválido sem país" do
    track = build(:track, country: nil)
    expect(track).not_to be_valid
  end

  it "é inválido sem elevação" do
    track = build(:track, elevation_track: nil)
    expect(track).not_to be_valid
  end
end
