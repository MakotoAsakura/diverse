# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

unless User.admin.find_by(email: "super_admin@diverse-work.com")
  User.admin.create! email: "super_admin@diverse-work.com", password: "123456", confirmed_at: Time.current,
                     manage_attributes: { first_name: "Super", last_name: "Admin" }
end

unless SystemSetting.last
  SystemSetting.create!(
    transportation_allowance: 0,
    settlement_expiration_date: "22",
    settlement_date: "22",
    settlement_hour: "Mon, 22 Aug 2022 00:00:00.000000000 JST +09:00",
    payment_due_month: 0,
    payment_due_date: "end_of_month",
    invoice_name: "請求元名 ニュン",
    zipcode: "0920001",
    address: "123123",
    phone_number: "0311112222",
    bank_name: "BANK NAME",
    branch_name: "1234",
    account_type: "usually",
    account_number: "123456",
    holder_name: "1233",
    holder_name_kana: "カナ",
    system_fee: 10,
    pharmaceutical_introduction_fee: 10,
    job_acceptance_waiting_alert: 1,
    time_approval_waiting_alert: 1,
    registration_review_approval_waiting_alert: 1,
    email_contact: "admin@diverse-work.com",
  )
end
