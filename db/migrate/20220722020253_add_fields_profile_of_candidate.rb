class AddFieldsProfileOfCandidate < ActiveRecord::Migration[7.0]
  def change
    add_column :candidates, :graduation_year, :integer, null:false
    add_column :candidates, :specialization, :string
    add_column :candidates, :skill, :string
    add_column :candidates, :certificates, :string, default: [].to_yaml
    add_column :candidates, :other_certificates, :string
  end
end
