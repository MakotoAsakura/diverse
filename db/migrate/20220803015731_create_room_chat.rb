class CreateRoomChat < ActiveRecord::Migration[7.0]
  def change
    create_table :room_chats do |t|
      t.bigint :first_user_id, index: true, null: false
      t.bigint :second_user_id, index: true, null: false
      t.string :room_code
      t.text :last_message
      t.bigint :last_sender_id, index: true
      t.datetime :read_at
      t.datetime :sent_at

      t.timestamps
    end
  end
end
