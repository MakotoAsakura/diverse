class CreateNotificationUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :notification_users do |t|
      t.references :user, null: false
      t.references :notification, null: false
      t.datetime :read_at, null: false

      t.timestamps
    end
  end
end
