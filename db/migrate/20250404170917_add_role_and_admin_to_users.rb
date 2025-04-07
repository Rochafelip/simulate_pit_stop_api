class AddRoleAndAdminToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :role, :integer, default: 0
    add_column :users, :admin, :boolean, default: false
  end
end
