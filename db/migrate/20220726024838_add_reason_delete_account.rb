class AddReasonDeleteAccount < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :reason_delete, :string
  end
end
