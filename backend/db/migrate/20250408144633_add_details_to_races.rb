class AddDetailsToRaces < ActiveRecord::Migration[7.2]
  def change
    # Adicionando as colunas car_name, car_category e track_name
    add_column :races, :car_name, :string
    add_column :races, :car_category, :string
    add_column :races, :track_name, :string

    add_column :races, :race_time_minutes, :integer
    add_column :races, :mandatory_pit_stop, :boolean, default: false
    add_column :races, :planned_pit_stops, :integer

    # Preenchendo os campos car_name, car_category e track_name com base nos dados das tabelas associadas
    Race.find_each do |race|
      race.update_columns(
        car_name: race.car.model,
        car_category: race.car.category,
        track_name: race.track.name
      )
    end
  end
end
