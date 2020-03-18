class RemoveStatusToTasks < ActiveRecord::Migration[5.2]
  def change
    remove_column :tasks, :status, :string
  end
end
