class AddInformationShiftToAttendance < ActiveRecord::Migration[7.0]
  def change
    add_column :attendances, :shift_2_checkout, :datetime, after: :checkout
    add_column :attendances, :shift_2_checkin, :datetime, after: :checkout
    add_column :attendances, :shift_1_checkout, :datetime, after: :checkout
    add_column :attendances, :shift_1_checkin, :datetime, after: :checkout
  end
end
