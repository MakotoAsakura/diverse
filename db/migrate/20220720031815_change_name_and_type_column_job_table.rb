class ChangeNameAndTypeColumnJobTable < ActiveRecord::Migration[7.0]
  def change
    change_column :jobs, :wday_start_at, :float
    change_column :jobs, :wday_end_at, :float
    rename_column :jobs, :wday_start_at, :hours_wday_min
    rename_column :jobs, :wday_end_at, :hours_wday_max
  end
end
