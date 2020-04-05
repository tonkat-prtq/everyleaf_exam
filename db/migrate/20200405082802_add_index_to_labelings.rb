class AddIndexToLabelings < ActiveRecord::Migration[5.2]
  def change
    add_index :labelings, [:label_id, :task_id], unique: true
  end
end
