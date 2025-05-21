require 'rails_helper'

RSpec.describe Race, type: :model do
  let(:user) { create(:user) }
  let(:car) { create(:car) }
  let(:track) { create(:track) }

  it "é válido com atributos obrigatórios" do
    race = build(:race,
      car: car,
      track: track,
      user: user,
      total_laps: 50,
      fuel_consumption_per_lap: 2.5,
      average_lap_time: 90.5,
      total_fuel_needed: 125.0,
      race_time_minutes: 100,
      mandatory_pit_stop: true,
      planned_pit_stops: 2,
      car_name: car.model,
      car_category: car.category,
      track_name: track.name
    )

    expect(race).to be_valid
  end

  it "é inválido sem usuário" do
    race = build(:race,
      car: car,
      track: track,
      user: nil,
      fuel_consumption_per_lap: 2.5,
      average_lap_time: 90.5,
      race_time_minutes: 100,
      planned_pit_stops: 2
    )

    expect(race).not_to be_valid
  end

  it "é inválido com pit stops negativos" do
    race = build(:race,
      car: car,
      track: track,
      user: user,
      fuel_consumption_per_lap: 2.5,
      average_lap_time: 90.5,
      race_time_minutes: 100,
      planned_pit_stops: -1
    )

    expect(race).not_to be_valid
  end

  it "pertence a um carro, pista e usuário" do
    race = create(:race,
      car: car,
      track: track,
      user: user,
      total_laps: 30,
      fuel_consumption_per_lap: 2.5,
      average_lap_time: 80.0,
      total_fuel_needed: 100.0,
      race_time_minutes: 90,
      planned_pit_stops: 1
    )

    expect(race.car).to eq(car)
    expect(race.track).to eq(track)
    expect(race.user).to eq(user)
  end
end
