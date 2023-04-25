# frozen_string_literal: true

require "test_helper"

class PayslipDecoratorTest < ActiveSupport::TestCase
  def setup
    @payslip = Payslip.new.extend PayslipDecorator
  end

  # test "the truth" do
  #   assert true
  # end
end
