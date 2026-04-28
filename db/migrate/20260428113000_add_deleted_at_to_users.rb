class AddDeletedAtToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :deleted_at, :datetime

    remove_index :users, :email
    add_index :users, :email, unique: true, where: "deleted_at IS NULL"
    add_index :users, :deleted_at
  end
end
