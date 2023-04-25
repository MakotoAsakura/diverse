class RevertNameAndTypeColumnJobTable < ActiveRecord::Migration[7.0]
  def change
    change_column :jobs, :hours_wday_min, :datetime
    change_column :jobs, :hours_wday_max, :datetime
    rename_column :jobs, :hours_wday_min, :wday_start_at
    rename_column :jobs, :hours_wday_max, :wday_end_at
  end
end
