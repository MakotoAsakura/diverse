# frozen_string_literal: true

require "test_helper"

class CandidateJobDecoratorTest < ActiveSupport::TestCase
  def setup
    @candidate_job = CandidateJob.new.extend CandidateJobDecorator
  end

  # test "the truth" do
  #   assert true
  # end
end
