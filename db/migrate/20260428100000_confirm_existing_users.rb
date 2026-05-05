class ConfirmExistingUsers < ActiveRecord::Migration[8.1]
  def up
    execute <<~SQL
      UPDATE users
      SET confirmed_at = COALESCE(confirmed_at, CURRENT_TIMESTAMP),
          confirmation_token = NULL,
          confirmation_sent_at = NULL
      WHERE confirmed_at IS NULL
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
