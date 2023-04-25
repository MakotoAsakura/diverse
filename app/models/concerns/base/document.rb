# frozen_string_literal: true

module Base
  module Document
    extend ActiveSupport::Concern

    module ClassMethods
      def t(*args)
        human_attribute_name(*args)
      end
    end

    def t(name, opts = {})
      self.class.t name, opts
    end
  end
end
