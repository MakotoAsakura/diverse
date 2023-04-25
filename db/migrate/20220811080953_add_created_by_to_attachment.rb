class AddCreatedByToAttachment < ActiveRecord::Migration[7.0]
  def change
    add_column :attachments, :created_by_id, :integer
  end
end
