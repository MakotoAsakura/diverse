# frozen_string_literal: true

class CreateCandidateJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :candidate_jobs do |t|
      t.references :user, null: false
      t.references :candidate, null: false
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
