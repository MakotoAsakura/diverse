# frozen_string_literal: true

module SessionsHelper
  def create_session(role)
    if sign_in_params[:email].blank? || sign_in_params[:password].blank?
      self.resource = resource_class.new(sign_in_params)
      resource.errors.add(:email, :blank) if resource.email.blank?
      resource.errors.add(:password, :blank) if resource.password.blank?

      render "new" # rubocop:disable GitHub/RailsViewRenderPathsExist

      nil
    else
      self.resource = warden.authenticate(auth_options)
      if resource&.active_for_authentication?

        if resource.role == role
          # set_flash_message(:notice, :signed_in)
          sign_in(role.to_sym, resource)

          if session[:return_to] && ((session[:return_to].include?(role) && role == "admin") || (session[:return_to].include?(role) && role == "medical") || (session[:return_to].exclude?("admin" || "medical") && role == "user"))
            redirect_to session[:return_to]
            session.delete(:return_to)
            return
          end

          redirect_to send(redirect_path_success(role)) and return
        else
          set_flash_message(:danger, :invalid, { scope: "devise.failure" })

          redirect_to send(redirect_path_failure(role)) and return
        end
      end

      set_flash_message(:danger, :invalid, { now: true, scope: "devise.failure" })
      self.resource = resource_class.new(sign_in_params)
      render "new" # rubocop:disable GitHub/RailsViewRenderPathsExist
    end
  end

  private

  def redirect_path_failure(role)
    return "new_user_session_path" if role == "user"

    "new_#{role}_user_session_path"
  end

  def redirect_path_success(role)
    return "root_path" if role == "user"

    "#{role}_root_path"
  end
end
