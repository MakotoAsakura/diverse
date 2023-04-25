class AddMedicalReadAtToRoomChat < ActiveRecord::Migration[7.0]
  def change
    add_column :room_chats, :medical_read_at, :datetime
  end
end
