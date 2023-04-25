class AddCreatorToNotification < ActiveRecord::Migration[7.0]
  def change
    add_reference :notifications, :creator, foreign_key: { to_table: :users }, null: false, after: :end_time
  end
end
