# frozen_string_literal: true

module Employee
  module EmployeeHelper
    def total_messages_unseen
      return unless current_user

      RoomChat.unseen(current_user.id).count
    end
  end
end
