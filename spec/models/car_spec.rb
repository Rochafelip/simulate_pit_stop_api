require 'rails_helper'

RSpec.describe Car, type: :model do
    let(:valid_attributes) do
        {
        model: "BMW M4",
        power: 500,
        weight: 1500,
        fuel_capacity: 100,
        category: "GT3"
        }
    end

    it "é válido com todos os atributos obrigatórios corretamente preenchidos" do
        car = Car.new(valid_attributes)
        expect(car).to be_valid
      end

      it "é inválido sem modelo" do
        car = Car.new(valid_attributes.merge(model: nil))
        expect(car).not_to be_valid
      end

      it "é inválido com potência maior que 1500" do
        car = Car.new(valid_attributes.merge(power: 1600))
        expect(car).not_to be_valid
      end

      it "é inválido com peso menor que 500" do
        car = Car.new(valid_attributes.merge(weight: 400))
        expect(car).not_to be_valid
      end

      it "é inválido com capacidade de combustível maior que 300" do
        car = Car.new(valid_attributes.merge(fuel_capacity: 350))
        expect(car).not_to be_valid
      end

      it "é inválido com categoria fora da lista permitida" do
        car = Car.new(valid_attributes.merge(category: "Kart"))
        expect(car).not_to be_valid
      end

      it "é inválido se a razão potência/peso for irreal" do
        car = Car.new(valid_attributes.merge(power: 1600, weight: 1000)) # ratio = 1.6
        expect(car).not_to be_valid
      end

      it "é inválido com categoria fora da lista" do
        car = Car.new(model: "ProtoX", power: 300, weight: 1200, fuel_capacity: 80, category: "Truck")
        expect(car).not_to be_valid
        expect(car.errors[:category]).to be_present
      end

      it "é inválido se relação potência/peso for irreal" do
        car = Car.new(model: "ProtoX", power: 1500, weight: 1000, fuel_capacity: 80, category: "GT3")
        expect(car).not_to be_valid
        expect(car.errors[:base]).to be_present
      end

      it "pode ter muitas corridas associadas" do
        user = User.create!(name: "teste", email: "teste@example.com", password: "password123", password_confirmation: "password123")

        track = Track.create!(name: "Interlagos", distance: 4.3, number_of_curves: 15, country: "Brazil", elevation_track: 43)

        car = Car.create!(valid_attributes)

        race1 = Race.create!(car: car, track: track, user: user, total_laps: 30, fuel_consumption_per_lap: 2.5, average_lap_time: 90.0, race_time_minutes: 60, planned_pit_stops: 2)

        race2 = Race.create!(car: car, track: track, user: user, total_laps: 45, fuel_consumption_per_lap: 2.8, average_lap_time: 88.0, race_time_minutes: 75, planned_pit_stops: 3)

        expect(car.races).to include(race1, race2)
        expect(car.races.count).to eq(2)
      end
end
