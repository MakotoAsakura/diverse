class AddViewedDateToPayslips < ActiveRecord::Migration[7.0]
  def change
    add_column :payslips, :viewed_date, :datetime
  end
end
