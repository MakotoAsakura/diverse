class ChangeColumnRequirePharmaceuticalCompanyTable < ActiveRecord::Migration[7.0]
  def change
    change_column_null :pharmaceutical_companies, :zipcode, false
    change_column_null :pharmaceutical_companies, :location, false
    change_column_null :pharmaceutical_companies, :staff_ms, false
    change_column_null :pharmaceutical_companies, :email, false
  end
end
