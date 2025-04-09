class RaceCalculator
    def initialize(car, race)
      @car = car
      @race = race
    end

    def total_fuel_needed
      @race.fuel_consumption_per_lap * @race.total_laps
    end

    def minimum_pit_stops
      (total_fuel_needed / @car.fuel_capacity).ceil - 1
    end

    def pit_stops_sufficient?
      @race.planned_pit_stops >= minimum_pit_stops
    end

    def validate_mandatory_pit_stops(race)
      if race.mandatory_pit_stop && race.planned_pit_stops.zero?
        race.errors.add(:planned_pit_stops, "Pit stop obrigatório não planejado")
      end
    end
end
