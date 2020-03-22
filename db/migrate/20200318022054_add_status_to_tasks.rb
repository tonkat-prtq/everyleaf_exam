class AddStatusToTasks < ActiveRecord::Migration[5.2]
  def up
    add_column :tasks, :status, :integer
    change_column :tasks, :status, :integer, null: false, default: 0
  end

  def down
    remove_column :tasks, :status
  end
end
