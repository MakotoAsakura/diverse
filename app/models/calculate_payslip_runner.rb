# frozen_string_literal: true

class CalculatePayslipRunner < ApplicationRecord
  enum status: { running: 1, complete: 2 }, _default: :running
end
