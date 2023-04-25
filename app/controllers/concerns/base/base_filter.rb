# frozen_string_literal: true

module Base
  module BaseFilter
    extend ActiveSupport::Concern
    include Base::LayoutFilter

    included do
      cattr_accessor :model_class
      cattr_accessor :title
      cattr_accessor :group_action_new

      before_action :set_model
      before_action :set_group_action
    end

    module ClassMethods
      private

      def model(cls)
        self.model_class = cls if cls
      end

      def title_page(name)
        self.title = name if name
      end
    end

    private

    def set_model
      @model = self.class.model_class
    end

    def set_group_action
      @group_action_new = %w[new confirm create]
    end

    def rescue_action(exception)
      render_exception!(exception)
    end
  end
end
