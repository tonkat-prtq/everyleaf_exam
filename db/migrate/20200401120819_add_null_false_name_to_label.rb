class AddNullFalseNameToLabel < ActiveRecord::Migration[5.2]
  def up
    change_column :labels, :name, :string, null: false
  end

  def down
    change_column :labels, :name, :string, null: true
  end
end
