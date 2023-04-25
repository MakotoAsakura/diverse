# frozen_string_literal: true

module Employee
  class BanksController < EmployeeController
    include Base::BaseFilter
    include Base::CrudFilter

    before_action :set_item, except: %i[complete] # rubocop:disable Rails/LexicallyScopedActionFilter

    layout "employee/base"
    model Bank

    def create
      clear_session
      @item.attributes = find_params

      render_create @item.save
    end

    def confirm
      session[(controller_name + @model.name).to_sym] = find_params if params[:item].present?
      set_item
      @item.attributes = session[(controller_name + @model.name).to_sym]

      render_confirm @item.valid?
    end

    private

    def set_item
      @item = current_user.candidate.bank || current_user.candidate.build_bank
    end
  end
end
