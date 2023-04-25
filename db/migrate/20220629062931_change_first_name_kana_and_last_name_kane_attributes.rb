class ChangeFirstNameKanaAndLastNameKaneAttributes < ActiveRecord::Migration[7.0]
  def change
    change_column_null :medical_institutions, :name_kana, true
    change_column_null :candidates, :first_name_kana, true
    change_column_null :candidates, :last_name_kana, true
    add_column :medical_institutions, :status, :integer, default: 0, after: :last_name_kana_manager
    add_reference :medical_institutions, :creator, foreign_key: { to_table: :users }, null: false, after: :status
  end
end
