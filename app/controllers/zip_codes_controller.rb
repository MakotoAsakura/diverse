# frozen_string_literal: true

class ZipCodesController < ApplicationController
  def search
    jpostcodes = Jpostcode.find(params[:code])
    jpostcode = jpostcodes.is_a?(Array) ? jpostcodes.first : jpostcodes

    return if params[:code].blank?

    respond_to do |format|
      format.json { render json: { result: jpostcode } }
    end
  end
end
