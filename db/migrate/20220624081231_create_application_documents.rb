# frozen_string_literal: true

class CreateApplicationDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :application_documents do |t|
      t.references :candidate, null: false
      t.string :description

      t.timestamps
    end
  end
end
