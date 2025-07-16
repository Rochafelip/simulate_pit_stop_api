class ChangeDistanceInTracks < ActiveRecord::Migration[7.2]
  def change
    change_column :tracks, :distance, :float
  end
end
