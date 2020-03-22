class AddColumnToTask < ActiveRecord::Migration[5.2]
  def up
    add_column :tasks, :status, :string
    change_column :tasks, :status, :string, null: false, default: "未入力"
  end

  def down
    remove_column :tasks, :deadline
  end
end
