class RaceSimulator
    def initialize(race, pit_stop_time = 30)
      @race = race
      @pit_stop_time = pit_stop_time
    end

    def total_race_time
      lap_time_seconds = @race.average_lap_time * 60
      total_lap_time = lap_time_seconds * @race.total_laps
      total_pit_time = @pit_stop_time * @race.planned_pit_stops

      (total_lap_time + total_pit_time) / 60 # em minutos
    end
end
