class CreateManages < ActiveRecord::Migration[7.0]
  def change
    create_table :manages do |t|
      t.references :user, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false

      t.timestamps
    end
  end
end
