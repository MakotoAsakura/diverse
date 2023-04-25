class AddRejectNoteToAttendances < ActiveRecord::Migration[7.0]
  def change
    add_column :attendances, :reject_note, :text, after: :note
  end
end
