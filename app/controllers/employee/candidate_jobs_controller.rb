# frozen_string_literal: true

module Employee
  class CandidateJobsController < EmployeeController
    before_action :set_candidate_job

    def upload_attachment
      @candidate_job.update(upload_attachment_params)

      redirect_to request.referrer
    end

    private

    def upload_attachment_params
      params.require(:candidate_job).permit(
        { attachments_attributes: %i[description file created_by_id] }
      )
    end

    def set_candidate_job
      @candidate_job = CandidateJob.find_by(id: params[:id])
    end
  end
end
