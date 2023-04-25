# frozen_string_literal: true

module Medical
  class ContactsController < MedicalController
    include Base::BaseFilter
    include Base::CrudFilter

    skip_before_action :authenticate_medical_user!

    helper_method :current_candidate

    layout "medical/base"

    model Contact

    def new
      if params[:type] == "back"
        @item = @model.new pre_params.merge(session[(controller_name + @model.name).to_sym] || fix_params)
      else
        clear_session
        @item = @model.new pre_params.merge(fix_params)
      end

      render and return unless current_user

      @item.name ||= current_user.full_name
      @item.email ||= current_user.email

      render
    end
  end
end
