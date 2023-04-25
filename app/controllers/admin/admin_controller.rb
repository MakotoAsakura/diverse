# frozen_string_literal: true

module Admin
  class AdminController < ApplicationController
    before_action :authenticate_admin_user!
    helper_method :current_user

    def current_user
      current_admin_user
    end

    def authenticate_admin_user!
      session[:return_to] = request.original_url unless current_user

      super
    end
  end
end
