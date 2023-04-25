# frozen_string_literal: true

module Medical
  module MedicalHelper
    def total_messages_unseen
      return unless current_user

      RoomChat.medical_unseen(current_user.id).count
    end
  end
end
