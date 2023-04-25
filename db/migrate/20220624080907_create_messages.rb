# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.string :content, null: false
      t.references :room, null: false
      t.references :user, null: false

      t.timestamps
    end
  end
end
