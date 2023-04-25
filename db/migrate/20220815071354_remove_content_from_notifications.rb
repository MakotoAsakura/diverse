
class RemoveContentFromNotifications < ActiveRecord::Migration[7.0]
  def change
    remove_column :notifications, :content, :text
    remove_column :notifications, :user_id, :integer
    remove_column :notifications, :status, :integer
  end
end
