# frozen_string_literal: true

class JobEndJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    EndJobService.new(Time.current).perform
  end
end
