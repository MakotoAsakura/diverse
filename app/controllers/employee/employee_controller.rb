# frozen_string_literal: true

module Employee
  class EmployeeController < ApplicationController
    include EmployeeHelper
    layout "employee/base"
    before_action :authenticate_user!
    before_action :messages_unseen
    helper_method :current_candidate

    def messages_unseen
      @total_messages_unseen = total_messages_unseen
    end

    def current_candidate
      return unless current_user

      current_user.candidate
    end

    def authenticate_user!
      session[:return_to] = request.original_url unless current_user

      super
    end
  end
end
