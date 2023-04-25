class CreateProfile < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.datetime :date_start_work
      t.datetime :date_end_work
      t.string :note
      t.bigint :candidate_id, index: true, null: false
      t.timestamps
    end
  end
end
