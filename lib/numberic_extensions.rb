# frozen_string_literal: true

class Numeric
  def percent_of(total)
    total.to_f.zero? ? 0.0 : self / total.to_f * 100.0
  end
end
