# frozen_string_literal: true

module Base
  module ExceptionFilter
    extend ActiveSupport::Concern

    def render_exception!(exception)
      backtrace_cleaner = request.get_header("action_dispatch.backtrace_cleaner")
      wrapper = ::ActionDispatch::ExceptionWrapper.new(backtrace_cleaner, exception)
      log_error(request, wrapper)

      if exception.is_a?(Job::SizeLimitPerUserExceededError)
        render_job_size_limit(exception)
        return
      end

      status_code = if exception.is_a?(RuntimeError) && exception.message.numeric?
                      Integer(exception.message)
                    else
                      wrapper.status_code
                    end

      @ss_rescue = { status: status_code }
      @wrapper = wrapper if Rails.env.development?

      render(
        layout: @cur_user ? "ss/base" : "ss/login", status: status_code,
        type: request.xhr? ? "text/plain" : "text/html", formats: request.xhr? ? :text : :html
      )
    rescue StandardError => e
      Rails.logger.info("#{e.class} (#{e.message}):\n  #{e.backtrace.join("\n  ")}")
      raise exception
    end
  end
end
