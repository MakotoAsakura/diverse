class AddInfoToSystemSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :system_settings, :settlement_expiration_date, :string
    add_column :system_settings, :settlement_date, :string
    add_column :system_settings, :settlement_hour, :datetime
    add_column :system_settings, :payment_due_month, :integer, comment: "0: 当月 / 1: 翌月 / 2: 翌々月と"
    add_column :system_settings, :payment_due_date, :string
    add_column :system_settings, :invoice_name, :string
    add_column :system_settings, :zipcode, :string
    add_column :system_settings, :address, :string
    add_column :system_settings, :phone_number, :string
    add_column :system_settings, :bank_name, :string
    add_column :system_settings, :branch_name, :string
    add_column :system_settings, :account_type, :integer, comment: "0: 普通 / 1: 当座"
    add_column :system_settings, :account_number, :string
    add_column :system_settings, :holder_name, :string
    add_column :system_settings, :holder_name_kana, :string
    add_column :system_settings, :system_fee, :integer, comment: "in percent"
    add_column :system_settings, :pharmaceutical_introduction_fee, :integer, comment: "in percent"
    add_column :system_settings, :job_acceptance_waiting_alert, :integer, comment: "by date"
    add_column :system_settings, :time_approval_waiting_alert, :integer, comment: "by date"
    add_column :system_settings, :registration_review_approval_waiting_alert, :integer, comment: "by date"
    add_column :system_settings, :email_contact, :string
  end
end
