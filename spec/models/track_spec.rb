require 'rails_helper'

RSpec.describe Track, type: :model do
  let(:valid_attributes) do
    {
      name: "Interlagos",
      distance: 4.3,
      number_of_curves: 15,
      country: "Brazil",
      elevation_track: 43
    }
  end

  it "é válido com todos os atributos preenchidos corretamente" do
    track = Track.new(valid_attributes)
    expect(track).to be_valid
  end

  it "é inválido sem nome" do
    track = Track.new(valid_attributes.except(:name))
    expect(track).not_to be_valid
  end

  it "é inválido sem distância" do
    track = Track.new(valid_attributes.except(:distance))
    expect(track).not_to be_valid
  end

  it "é inválido sem número de curvas" do
    track = Track.new(valid_attributes.except(:number_of_curves))
    expect(track).not_to be_valid
  end

  it "é inválido sem país" do
    track = Track.new(valid_attributes.except(:country))
    expect(track).not_to be_valid
  end

  it "é inválido sem elevação da pista" do
    track = Track.new(valid_attributes.except(:elevation_track))
    expect(track).not_to be_valid
  end

  it "é inválido com distância fora dos limites permitidos" do
    track = Track.new(valid_attributes.merge(distance: 30.0)) # > 25.0
    expect(track).not_to be_valid
  end

  it "é inválido com número de curvas fora dos limites" do
    track = Track.new(valid_attributes.merge(number_of_curves: 60)) # > 50
    expect(track).not_to be_valid
  end

  it "é inválido com elevação acima do permitido" do
    track = Track.new(valid_attributes.merge(elevation_track: 350)) # > 300
    expect(track).not_to be_valid
  end

  it "é inválido com país fora da lista válida" do
    track = Track.new(valid_attributes.merge(country: "Wakanda"))
    expect(track).not_to be_valid
  end

  it "é inválido com nome duplicado (case insensitive)" do
    Track.create!(valid_attributes)
    duplicate_track = Track.new(valid_attributes.merge(name: "INTERLAGOS"))
    expect(duplicate_track).not_to be_valid
  end

  # it "não apaga corridas associadas ao ser destruída (dependent: :nullify)" do
  #   track = Track.create!(valid_attributes)
  #   race = Race.create!(name: "GP Brasil", date: Date.today, track: track)
  #   track.destroy
  #   race.reload
  #   expect(race.track_id).to be_nil
  # end
end
