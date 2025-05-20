class RaceCalculator
  def initialize(car, race)
    @car = car
    @race = race
  end

  def total_fuel_needed
    return 0 unless @race.fuel_consumption_per_lap && @race.total_laps

    @race.fuel_consumption_per_lap * @race.total_laps
  end

  def minimum_pit_stops
    fuel_needed = total_fuel_needed
    tank_capacity = @car&.fuel_capacity

    return 0 if fuel_needed.zero? || tank_capacity.blank? || tank_capacity.zero?

    (fuel_needed / tank_capacity.to_f).ceil
  end

  def pit_stops_sufficient?
    planned = @race.planned_pit_stops.to_i
    planned >= minimum_pit_stops
  end

  def validate_mandatory_pit_stops(race = @race)
    !race.mandatory_pit_stop || race.planned_pit_stops.to_i > 0
  end
end
