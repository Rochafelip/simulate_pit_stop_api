FactoryBot.define do
    factory :race do
      user
      car
      track
      total_laps { 50 }
      fuel_consumption_per_lap { 2.5 }
      average_lap_time { 90.5 }
      total_fuel_needed { 125.0 }
      race_time_minutes { 100 }
      mandatory_pit_stop { true }
      planned_pit_stops { 2 }
      car_name { car.model }
      car_category { car.category }
      track_name { track.name }
    end
  end
