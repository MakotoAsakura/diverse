# frozen_string_literal: true

class CustomFailure < Devise::FailureApp
  def redirect_url
    controller_name = request.parameters["controller"]
    site_name = controller_name.split("/")[0]

    case site_name
    when "admin"
      new_admin_user_session_url
    when "medical"
      new_medical_user_session_url
    else
      new_user_session_url
    end
  end

  # You need to override respond to eliminate recall
  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end
