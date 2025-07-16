class CreateTracks < ActiveRecord::Migration[7.2]
  def change
    create_table :tracks do |t|
      t.string :name, null: false
      t.integer :distance, null: false
      t.integer :number_of_curves, null: false
      t.string :country, null: false
      t.integer :elevation_track, null: false

      t.timestamps
    end
  end
end
