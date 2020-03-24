class ChangeColumnNullUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :name, :string, null: false
    change_column :users, :email, :string, null: false
    change_column :users, :password_digest, :string, null: false
  end
end
