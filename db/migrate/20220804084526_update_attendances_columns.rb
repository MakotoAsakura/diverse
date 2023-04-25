class UpdateAttendancesColumns < ActiveRecord::Migration[7.0]
  def change
    rename_column :attendances, :salary_details_according_to, :transportation_fee
    add_column :attendances, :work_hours, :decimal, precision: 5, scale: 2, null: false
    add_column :attendances, :break_hours, :decimal, precision: 5, scale: 2, null: false
  end
end
