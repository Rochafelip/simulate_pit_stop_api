Track.delete_all
Car.delete_all
User.delete_all

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
  { email: 'admin@example.com', name: 'Admin', password: 'password123', password_confirmation: 'password123', admin: true },
  { email: 'user1@example.com', name: 'Usuário Comum 1', password: 'password123', password_confirmation: 'password123', admin: false },
  { email: 'user2@example.com', name: 'Usuário Comum 2', password: 'password123', password_confirmation: 'password123', admin: false },
  { email: 'user3@example.com', name: 'Usuário Comum 3', password: 'password123', password_confirmation: 'password123', admin: false },
  { email: 'user4@example.com', name: 'Usuário Comum 4', password: 'password123', password_confirmation: 'password123', admin: false }
])
