# frozen_string_literal: true

module Admin
  class TaxWithholdingsController < ApplicationController
    include Base::BaseFilter
    include Base::CrudFilter

    layout "admin/base"
    model TaxWithholding

    def index
      @items = @model.where(kind: params[:type]).from_asc.page(params[:page]).per(20)
    end

    def create
      clear_session
      @item = @model.new find_params
      render js: "location.reload()" if @item.save
    end

    def update
      @item.attributes = find_params
      render js: "location.reload()" if @item.save
    end

    def destroy
      redirect_to admin_tax_withholdings_path(type: params[:type]) if @item.destroy
    end

    def import
      if params[:file] && [".csv", ".xls", ".xlsx"].include?(File.extname(params[:file].original_filename))
        if TaxWithholding.import_file params[:file]
          flash[:success] = t("tax_withholding.import.success")
        else
          flash[:error] = t("tax_withholding.errors.invalid")
        end
      else
        flash[:error] = t("tax_withholding.errors.please_import_file")
      end
    rescue StandardError
      flash[:error] = t("tax_withholding.errors.invalid")
    ensure
      redirect_to admin_tax_withholdings_path(type: "normal")
    end
  end
end
