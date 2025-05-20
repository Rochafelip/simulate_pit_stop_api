# app/services/race_metrics_service.rb
class RaceMetricsService
  def initialize(race)
    @race = race
    @calculator = RaceCalculator.new(race.car, race)
    @simulator = RaceSimulator.new(race)
  end

  def compute_all_metrics
    {
      total_fuel_needed: @calculator.total_fuel_needed,
      minimum_pit_stops: @calculator.minimum_pit_stops,
      pit_stops_sufficient: @calculator.pit_stops_sufficient?,
      mandatory_pit_stop_valid: @calculator.validate_mandatory_pit_stops,
      total_race_time: @simulator.total_race_time,
      fuel_per_pit_stop: fuel_per_pit_stop,
      estimated_pit_time: estimated_pit_time
    }
  end

  private

  def fuel_per_pit_stop
    return 0 if @race.planned_pit_stops.zero?
    @calculator.total_fuel_needed / (@race.planned_pit_stops + 1)
  end

  def estimated_pit_time
    @race.planned_pit_stops * 30
  end
end
