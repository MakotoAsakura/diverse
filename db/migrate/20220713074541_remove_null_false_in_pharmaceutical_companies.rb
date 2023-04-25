class RemoveNullFalseInPharmaceuticalCompanies < ActiveRecord::Migration[7.0]
  def change
    change_column_null :pharmaceutical_companies, :zipcode, true
    change_column_null :pharmaceutical_companies, :location, true
    change_column_null :pharmaceutical_companies, :email, true
    change_column_null :medical_institutions, :creator_id, true
  end
end
