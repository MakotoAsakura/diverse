# frozen_string_literal: true

module Admin
  class PasswordsController < Devise::PasswordsController
    include Base::BaseFilter
    include Base::LayoutFilter
    include SessionsHelper

    layout "admin/base"

    def send_mail_success; end

    def finish; end

    protected

    def after_sending_reset_password_instructions_path_for(_resource_name)
      admin_passwords_send_mail_success_path
    end

    def after_resetting_password_path_for(resource)
      AdminMailer.after_resetting_password(resource).deliver_later
      admin_passwords_finish_path
    end
  end
end
