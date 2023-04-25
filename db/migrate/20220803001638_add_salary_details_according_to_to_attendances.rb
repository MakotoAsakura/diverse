class AddSalaryDetailsAccordingToToAttendances < ActiveRecord::Migration[7.0]
  def change
    add_column :attendances, :salary_details_according_to, :integer
  end
end
