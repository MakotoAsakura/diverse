# frozen_string_literal: true

module Employee
  class TermsController < EmployeeController
    skip_before_action :authenticate_user!
    layout "employee/base"

    def index; end
  end
end
