require 'rails_helper'

RSpec.describe Race, type: :model do
  let(:user) do
    User.create!(
      email: "user@example.com",
      password: "password123",
      password_confirmation: "password123",
      name: "Test User"
    )
  end

  let(:car) do
    Car.create!(
      model: "Porsche 911",
      power: 500,
      weight: 1300,
      fuel_capacity: 100,
      category: "GT3"
    )
  end

  let(:track) do
    Track.create!(
      name: "Interlagos",
      distance: 4.3,
      number_of_curves: 15,
      country: "Brazil",
      elevation_track: 43
    )
  end

  it "é válido com atributos obrigatórios" do
    race = Race.new(
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
      car_name: "Porsche 911",
      car_category: "GT3",
      track_name: "Interlagos"
    )

    expect(race).to be_valid
  end

  it "é inválido sem usuário" do
    race = Race.new(
      car: car,
      track: track,
      fuel_consumption_per_lap: 2.5,
      average_lap_time: 90.5,
      race_time_minutes: 100,
      planned_pit_stops: 2
    )

    expect(race).not_to be_valid
  end

  it "é inválido com pit stops negativos" do
    race = Race.new(
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
    race = Race.create!(
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
