# frozen_string_literal: true

require "test_helper"

class ZipCodesControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get zip_codes_search_url
    assert_response :success
  end
end
