class CreateRaces < ActiveRecord::Migration[7.2]
  def change
    create_table :races do |t|
      t.references :car, null: false, foreign_key: true
      t.references :track, null: false, foreign_key: true
      t.integer :total_laps
      t.float :fuel_consumption_per_lap
      t.float :average_lap_time
      t.float :total_fuel_needed

      t.timestamps
    end
  end
end
