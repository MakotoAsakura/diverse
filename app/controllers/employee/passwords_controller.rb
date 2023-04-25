# frozen_string_literal: true

module Employee
  class PasswordsController < Devise::PasswordsController
    include Base::LayoutFilter
    include SessionsHelper

    layout "employee/base"

    def send_mail_success; end

    def finish; end

    protected

    def after_sending_reset_password_instructions_path_for(_resource_name)
      passwords_send_mail_success_path
    end

    def after_resetting_password_path_for(resource)
      CandidateMailer.after_resetting_password(resource).deliver_later
      passwords_finish_path
    end
  end
end
