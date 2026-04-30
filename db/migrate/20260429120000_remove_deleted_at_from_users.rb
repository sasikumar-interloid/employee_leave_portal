class RemoveDeletedAtFromUsers < ActiveRecord::Migration[8.1]
  def change
    remove_index :users, :deleted_at if index_exists?(:users, :deleted_at)
    remove_index :users, :email if index_exists?(:users, :email)
    add_index :users, :email, unique: true

    remove_column :users, :deleted_at, :datetime if column_exists?(:users, :deleted_at)
  end
end
