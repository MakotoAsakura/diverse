# frozen_string_literal: true

module Medical
  class TermsController < MedicalController
    include Base::BaseFilter
    skip_before_action :authenticate_medical_user!
    layout "medical/base"

    def index; end
  end
end
