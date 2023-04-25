class AddInformationSalaryToJob < ActiveRecord::Migration[7.0]
  def change
    add_column :jobs, :including_transportation_allowance, :integer, default: 0, null: false, after: :salary_detail
    add_column :jobs, :salary_details_according_to, :integer, after: :salary_detail
    add_column :jobs, :salary_according_to, :integer, after: :max_annual_salary
  end
end
