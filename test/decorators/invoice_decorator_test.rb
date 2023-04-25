# frozen_string_literal: true

require "test_helper"

class InvoiceDecoratorTest < ActiveSupport::TestCase
  def setup
    @invoice = Invoice.new.extend InvoiceDecorator
  end

  # test "the truth" do
  #   assert true
  # end
end
