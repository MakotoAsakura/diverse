class ChangePositionAttributeOnJobTable < ActiveRecord::Migration[7.0]
  def change
    change_column :jobs, :position, :integer
    add_column :medical_institutions, :approved_date, :datetime, after: :status
    add_column :medical_institutions, :viewed_date, :datetime, after: :approved_date
  end
end
