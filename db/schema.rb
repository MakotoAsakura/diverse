# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_09_23_035731) do
  create_table "action_text_rich_texts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.text "body", size: :long
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "application_documents", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "candidate_id", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["candidate_id"], name: "index_application_documents_on_candidate_id"
  end

  create_table "attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "created_by_id"
  end

  create_table "attendances", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "medical_institution_id", null: false
    t.bigint "candidate_id", null: false
    t.bigint "job_id", null: false
    t.datetime "checkin"
    t.datetime "checkout"
    t.datetime "shift_1_checkin"
    t.datetime "shift_1_checkout"
    t.datetime "shift_2_checkin"
    t.datetime "shift_2_checkout"
    t.text "note"
    t.text "reject_note"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "transportation_fee"
    t.decimal "work_hours", precision: 5, scale: 2, null: false
    t.decimal "break_hours", precision: 5, scale: 2, null: false
    t.datetime "calculate_at"
    t.index ["candidate_id", "job_id"], name: "index_attendances_on_candidate_id_and_job_id"
    t.index ["candidate_id"], name: "index_attendances_on_candidate_id"
    t.index ["job_id"], name: "index_attendances_on_job_id"
    t.index ["medical_institution_id"], name: "index_attendances_on_medical_institution_id"
  end

  create_table "banks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "candidate_id", null: false
    t.string "bank_name"
    t.string "branch_name"
    t.integer "account_type"
    t.string "account_number"
    t.string "account_holder_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["candidate_id"], name: "index_banks_on_candidate_id"
  end

  create_table "calculate_payslip_runners", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "start_at", null: false
    t.datetime "end_at"
    t.integer "status", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "candidate_jobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "candidate_id", null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "viewed_date"
    t.integer "salary_detail"
    t.integer "salary_details_according_to"
    t.integer "including_transportation_allowance", default: 0, null: false
    t.text "remark"
    t.datetime "contract_start_at"
    t.datetime "contract_end_at"
    t.string "contract_id"
    t.datetime "employee_read_at"
    t.datetime "medical_read_at"
    t.index ["candidate_id"], name: "index_candidate_jobs_on_candidate_id"
    t.index ["job_id"], name: "index_candidate_jobs_on_job_id"
  end

  create_table "candidates", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "first_name_kana"
    t.string "last_name_kana"
    t.integer "gender"
    t.datetime "dob"
    t.string "zipcode"
    t.string "address"
    t.string "phone_number"
    t.text "experiences"
    t.text "diplomas"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "prefecture"
    t.string "city"
    t.integer "graduation_year"
    t.string "specialization"
    t.string "skill"
    t.string "certificates", default: "--- []\n"
    t.string "other_certificates"
    t.integer "national"
    t.index ["user_id"], name: "index_candidates_on_user_id"
  end

  create_table "contacts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "title"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoices", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "code"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "year", null: false
    t.integer "month", null: false
    t.integer "medical_institution_id", null: false
    t.integer "system_fee", null: false, comment: "in percent"
    t.decimal "subtotal", precision: 9, scale: 2, null: false
    t.decimal "tax", precision: 15, scale: 2, null: false, comment: "in percent"
    t.decimal "tax_money", precision: 9, scale: 2, null: false
    t.decimal "total", precision: 9, scale: 2, null: false
    t.datetime "settlement_date", null: false
    t.datetime "payment_due_date", null: false
  end

  create_table "jobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "medical_institution_id", null: false
    t.integer "status", default: 0, null: false
    t.string "title", null: false
    t.integer "position"
    t.string "address"
    t.integer "min_annual_salary"
    t.integer "max_annual_salary"
    t.integer "salary_according_to"
    t.integer "including_transportation_allowance", default: 0, null: false
    t.integer "quantity"
    t.datetime "open_at"
    t.datetime "close_at"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "wday_start_at", precision: nil
    t.datetime "wday_end_at", precision: nil
    t.string "wdays", default: "--- []\n"
    t.text "work_detail"
    t.text "appealing"
    t.text "require_skill"
    t.text "contact"
    t.text "work_policy"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medical_institution_id"], name: "index_jobs_on_medical_institution_id"
    t.index ["title"], name: "index_jobs_on_title"
  end

  create_table "manages", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_manages_on_user_id"
  end

  create_table "medical_institutions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.string "name_kana", null: false
    t.string "url", null: false
    t.string "zipcode", null: false
    t.string "location", null: false
    t.string "phone_number", null: false
    t.string "first_name_manager", null: false
    t.string "last_name_manager", null: false
    t.string "first_name_kana_manager", null: false
    t.string "last_name_kana_manager", null: false
    t.integer "status", default: 0
    t.datetime "approved_date"
    t.datetime "viewed_date"
    t.bigint "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "reason"
    t.index ["creator_id"], name: "index_medical_institutions_on_creator_id"
    t.index ["user_id"], name: "index_medical_institutions_on_user_id"
  end

  create_table "messages", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "content", null: false
    t.bigint "room_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_messages_on_room_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notification_users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "notification_id", null: false
    t.datetime "read_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notification_id"], name: "index_notification_users_on_notification_id"
    t.index ["user_id"], name: "index_notification_users_on_user_id"
  end

  create_table "notifications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.bigint "creator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_notifications_on_creator_id"
  end

  create_table "payslips", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "year", null: false
    t.integer "month", null: false
    t.decimal "total", precision: 15, scale: 2, default: "0.0"
    t.decimal "unit_price", precision: 15, scale: 2, default: "0.0", null: false
    t.decimal "total_hour", precision: 15, scale: 2, default: "0.0", null: false
    t.decimal "total_day", precision: 15, scale: 2, default: "0.0"
    t.decimal "total_transportation_fee", precision: 15, scale: 2, default: "0.0", null: false
    t.decimal "personal_income_tax", precision: 15, scale: 2, default: "0.0"
    t.decimal "tax_withholding", precision: 15, scale: 2, default: "0.0"
    t.integer "salary_according_to", default: 0
    t.bigint "candidate_id", null: false
    t.bigint "medical_institution_id", null: false
    t.integer "job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "viewed_date"
    t.index ["candidate_id"], name: "index_payslips_on_candidate_id"
    t.index ["medical_institution_id"], name: "index_payslips_on_medical_institution_id"
  end

  create_table "pharmaceutical_companies", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "medical_institution_id", null: false
    t.string "name", null: false
    t.string "phone_number"
    t.string "zipcode"
    t.string "location"
    t.string "staff_ms", null: false
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medical_institution_id"], name: "index_pharmaceutical_companies_on_medical_institution_id"
    t.index ["name"], name: "index_pharmaceutical_companies_on_name"
  end

  create_table "profiles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "date_start_work"
    t.datetime "date_end_work"
    t.string "note"
    t.bigint "candidate_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["candidate_id"], name: "index_profiles_on_candidate_id"
  end

  create_table "room_chats", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "first_user_id", null: false
    t.bigint "second_user_id", null: false
    t.string "room_code"
    t.text "last_message"
    t.bigint "last_sender_id"
    t.datetime "read_at"
    t.datetime "sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "medical_read_at"
    t.index ["first_user_id"], name: "index_room_chats_on_first_user_id"
    t.index ["last_sender_id"], name: "index_room_chats_on_last_sender_id"
    t.index ["second_user_id"], name: "index_room_chats_on_second_user_id"
  end

  create_table "rooms", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "system_settings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "transportation_allowance", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "settlement_expiration_date"
    t.string "settlement_date"
    t.datetime "settlement_hour"
    t.integer "payment_due_month", comment: "0: 当月 / 1: 翌月 / 2: 翌々月と"
    t.string "payment_due_date"
    t.string "invoice_name"
    t.string "zipcode"
    t.string "address"
    t.string "phone_number"
    t.string "bank_name"
    t.string "branch_name"
    t.integer "account_type", comment: "0: 普通 / 1: 当座"
    t.string "account_number"
    t.string "holder_name"
    t.string "holder_name_kana"
    t.integer "system_fee", comment: "in percent"
    t.integer "pharmaceutical_introduction_fee", comment: "in percent"
    t.integer "job_acceptance_waiting_alert", comment: "by date"
    t.integer "time_approval_waiting_alert", comment: "by date"
    t.integer "registration_review_approval_waiting_alert", comment: "by date"
    t.string "email_contact"
  end

  create_table "tax_withholdings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "from"
    t.integer "to"
    t.string "tax"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "kind"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", null: false
    t.integer "role", default: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "discarded_at"
    t.string "reason_delete"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["discarded_at"], name: "index_users_on_discarded_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "application_documents", "candidates"
  add_foreign_key "attendances", "candidates"
  add_foreign_key "attendances", "medical_institutions"
  add_foreign_key "banks", "candidates"
  add_foreign_key "candidate_jobs", "candidates"
  add_foreign_key "candidate_jobs", "jobs"
  add_foreign_key "candidates", "users"
  add_foreign_key "jobs", "medical_institutions"
  add_foreign_key "medical_institutions", "users"
  add_foreign_key "medical_institutions", "users", column: "creator_id"
  add_foreign_key "messages", "rooms"
  add_foreign_key "messages", "users"
  add_foreign_key "notifications", "users", column: "creator_id"
  add_foreign_key "payslips", "candidates"
  add_foreign_key "payslips", "medical_institutions"
  add_foreign_key "pharmaceutical_companies", "medical_institutions"
end
