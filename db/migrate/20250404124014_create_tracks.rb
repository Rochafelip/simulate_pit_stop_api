class CreateTracks < ActiveRecord::Migration[7.2]
  def change
    create_table :tracks do |t|
      t.string :name
      t.integer :distance
      t.integer :number_of_curves
      t.string :country
      t.integer :elevation_track

      t.timestamps
    end
  end
end
