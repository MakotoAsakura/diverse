# frozen_string_literal: true

module Employee
  module CandidatesHelper
    def convert_password_to_asterisk(candidate)
      "*" * (candidate.password&.length || 6)
    end

    def gender_text(candidate)
      if candidate.male?
        "男性"
      elsif candidate.female?
        "女性"
      else
        ""
      end
    end

    def national_text(candidate)
      if candidate.japan?
        "日本国籍"
      elsif candidate.non_japan?
        "外国籍"
      else
        ""
      end
    end
  end
end
