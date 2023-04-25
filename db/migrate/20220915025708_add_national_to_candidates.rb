class AddNationalToCandidates < ActiveRecord::Migration[7.0]
  def change
    add_column :candidates, :national, :integer
  end
end
