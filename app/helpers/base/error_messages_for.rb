# frozen_string_literal: true

module Base
  module ErrorMessagesFor
    extend ActiveSupport::Concern

    def error_messages_for(object, header_message: nil); end
  end
end
