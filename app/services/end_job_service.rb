# frozen_string_literal: true

class EndJobService
  def initialize(time)
    @time = time
  end

  def perform
    job_ends = Job.published.where(end_at: @time.all_day)

    job_ends.find_each { |job_end| job_end.update(status: "ended") }
  end
end
