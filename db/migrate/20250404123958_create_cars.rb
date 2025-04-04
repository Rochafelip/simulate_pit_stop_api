class CreateCars < ActiveRecord::Migration[7.2]
  def change
    create_table :cars do |t|
      t.string :model
      t.integer :power
      t.integer :weight
      t.integer :fuel_capacity
      t.string :category

      t.timestamps
    end
  end
end
