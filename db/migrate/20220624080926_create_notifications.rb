# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false
      t.string :title, null: false
      t.text :content
      t.integer :status, default: 0
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
