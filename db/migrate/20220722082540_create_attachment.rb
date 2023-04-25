class CreateAttachment < ActiveRecord::Migration[7.0]
  def change
    create_table :attachments do |t|
      t.string :owner_type
      t.bigint :owner_id
      t.string :description

      t.timestamps
    end
  end
end
