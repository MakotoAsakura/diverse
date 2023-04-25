# frozen_string_literal: true

require "test_helper"

class MedicalInstitutionDecoratorTest < ActiveSupport::TestCase
  def setup
    @medical_institution = MedicalInstitution.new.extend MedicalInstitutionDecorator
  end

  # test "the truth" do
  #   assert true
  # end
end
