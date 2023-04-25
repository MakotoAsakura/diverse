class CreateSystemSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :system_settings do |t|
      t.integer :transportation_allowance, default: 0, null: false

      t.timestamps
    end
  end
end
