# frozen_string_literal: true

class CreateAttendances < ActiveRecord::Migration[7.0]
  def change
    create_table :attendances do |t|
      t.references :medical_institution, null: false
      t.references :candidate, null: false
      t.datetime :checkin
      t.datetime :checkout
      t.text :note
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
