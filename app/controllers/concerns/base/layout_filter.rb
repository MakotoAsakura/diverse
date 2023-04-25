# frozen_string_literal: true

module Base
  module LayoutFilter
    extend ActiveSupport::Concern

    included do
      cattr_accessor(:navi_view_file) { nil }
    end

    module ClassMethods
      private

      def navi_view(file)
        self.navi_view_file = file
      end
    end
  end
end
