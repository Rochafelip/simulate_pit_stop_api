class ChangeRaceFieldsToNotNull < ActiveRecord::Migration[7.2]
  def change
    change_column_null :races, :average_lap_time, false
    change_column_null :races, :fuel_consumption_per_lap, false
    change_column_null :races, :race_time_minutes, false
    change_column_null :races, :planned_pit_stops, false
  end
end
