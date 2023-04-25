# frozen_string_literal: true

require "test_helper"

class SystemSettingDecoratorTest < ActiveSupport::TestCase
  def setup
    @system_setting = SystemSetting.new.extend SystemSettingDecorator
  end

  # test "the truth" do
  #   assert true
  # end
end
