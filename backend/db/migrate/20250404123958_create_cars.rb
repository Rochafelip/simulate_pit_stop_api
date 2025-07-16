class CreateCars < ActiveRecord::Migration[7.2]
  def change
    create_table :cars do |t|
      t.string :model, null: false
      t.integer :power, null: false
      t.integer :weight, null: false
      t.integer :fuel_capacity, null: false
      t.string :category, null: false

      t.timestamps
    end
  end
end
