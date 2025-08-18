Car.destroy_all
Track.destroy_all
User.destroy_all
Race.destroy_all

Car.create!([
  { model: "Porsche 911 GT3 R", power: 520, weight: 1220, fuel_capacity: 120, category: "GT3" },
  { model: "Ferrari 488 GT3 Evo 2020", power: 620, weight: 1220, fuel_capacity: 110, category: "GT3" },
  { model: "Audi R8 LMS GT3 Evo II", power: 585, weight: 1230, fuel_capacity: 115, category: "GT3"},
  { model: "Mercedes-AMG GT3", power: 570, weight: 1250, fuel_capacity: 120, category: "GT3" },
  { model: "McLaren 720S GT3", power: 620, weight: 1230, fuel_capacity: 115, category: "GT3" }
])

Track.create!([
  { name: "Autodromo Nazionale Monza", distance: 5.793, number_of_curves: 11, country: "Italy", elevation_track: 0 },
  { name: "Autódromo José Carlos Pace (Interlagos)", distance: 4.309, number_of_curves: 15, country: "Brazil", elevation_track: 43 },
  { name: "Fuji Speedway", distance: 4.563, number_of_curves: 16, country: "Japan", elevation_track: 40 },
  { name: "Circuit de la Sarthe", distance: 13.629, number_of_curves: 38, country: "France", elevation_track: 22 },
  { name: "Bahrain International Circuit", distance: 5.412, number_of_curves: 15, country: "Bahrain", elevation_track: 3 },
  { name: "Mount Panorama Circuit - Bathurst", distance: 6.213, number_of_curves: 23, country: "Australia", elevation_track: 174 },
  { name: "Circuito de Mônaco", distance: 3.337, number_of_curves: 19, country: "Monaco", elevation_track: 42 }
])

User.create!([
  {email: "user1@example.com", name: "User 1 Teste", password: "password123", password_confirmation: "password123", confirmed_at: Time.current},
  {email: "user2@example.com", name: "User 2 Teste", password: "password123", password_confirmation: "password123", confirmed_at: Time.current}
])

user1 = User.find_by!(email: "user1@example.com")
user2 = User.find_by!(email: "user2@example.com")

car1 = Car.find_or_create_by!(model: "Porsche 911 GT3 R")
track1 = Track.find_or_create_by!(name: "Autodromo Nazionale Monza")

car2 = Car.find_or_create_by!(model: "McLaren 720S GT3")
track2 = Track.find_or_create_by!(name: "Circuit de la Sarthe")

begin
  Race.create!(
    user: user1,
    car: car1,
    track: track1,
    total_laps: 30,
    fuel_consumption_per_lap: 2.0,
    average_lap_time: 95,
    race_time_minutes: 45,
    mandatory_pit_stop: true,
    planned_pit_stops: 1
  )
rescue ActiveRecord::RecordInvalid => e
  puts "Erro criando Race 1: #{e.record.errors.full_messages.join(', ')}"
end

begin
  Race.create!(
    user: user2,
    car: car2,
    track: track2,
    total_laps: 20,
    fuel_consumption_per_lap: 2.5,
    average_lap_time: 130,
    race_time_minutes: 60,
    mandatory_pit_stop: false,
    planned_pit_stops: 0
  )
rescue ActiveRecord::RecordInvalid => e
  puts "Erro criando Race 2: #{e.record.errors.full_messages.join(', ')}"
end
