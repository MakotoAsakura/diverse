# frozen_string_literal: true

class CreateJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :jobs do |t|
      t.references :medical_institution, null: false
      t.string :title, limit: 255, null: false, index: true
      t.string :position, limit: 255
      t.string :address, limit: 255
      t.integer :min_annual_salary
      t.integer :max_annual_salary
      t.integer :salary_detail
      t.integer :quantity
      t.datetime :open_at
      t.datetime :close_at
      t.datetime :start_at
      t.datetime :end_at
      t.datetime :wday_start_at
      t.datetime :wday_end_at
      t.string :wdays, default: [].to_yaml
      t.text :work_detail
      t.text :appealing
      t.text :require_skill
      t.text :contact
      t.text :work_policy

      t.timestamps
    end
  end
end
