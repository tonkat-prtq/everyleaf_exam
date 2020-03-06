class AddColumnToTasks < ActiveRecord::Migration[5.2]
  def up
    add_column :tasks, :deadline, :datetime
    change_column :tasks, :deadline, :datetime, null: false, default: "未入力"
  end

  def down
    remove_column :tasks, :deadline
  end
end
