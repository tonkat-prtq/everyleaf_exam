class AddAdminToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :admin, :boolean, default: false, null: false
  end
end
