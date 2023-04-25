# frozen_string_literal: true

module Admin
  class SystemSettingsController < ApplicationController
    include Base::BaseFilter
    include Base::CrudFilter
    include SystemSettingDecorator

    layout "admin/base"
    model SystemSetting

    after_action -> { flash.discard }

    def confirm
      session[(controller_name + @model.name).to_sym] = find_params if params[:item].present?
      set_item
      @item.attributes = session[(controller_name + @model.name).to_sym]

      render_confirm @item.valid?
    end

    private

    def find_params
      params_permit = params.require(:item).permit(permit_fields)
      params_permit[:zipcode] = params_permit[:zipcode_first] + params_permit[:zipcode_last]
      params_permit.to_h.deep_merge(fix_params)
    rescue StandardError
      raise "400"
    end

    def set_item
      @item = @model.last
    end
  end
end
