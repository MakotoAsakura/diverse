# frozen_string_literal: true

module Admin
  module MedicalInstitutions
    module Candidates
      class AttendancesController < AdminController
        include Base::LayoutFilter

        layout "admin/base"

        def index
          @candidate = User.find(params[:candidate_id]).candidate
          @job = @candidate.job_workings.select("jobs.*, candidate_jobs.contract_start_at, candidate_jobs.contract_id").find(params[:job_id])
          @current_month = params[:month].present? ? Date.parse("#{params[:month]}-01") : Date.current
          @attendances = @candidate.attendances.where(job_id: @job.id).in_month(@current_month).index_by do |attendance|
            attendance.checkin.to_date.to_s
          end
          @current_url = "admin_medical_institution_candidate_attendances_path"

          set_pagination
          render "attendances" # rubocop:disable GitHub/RailsControllerRenderPathsExist
        end

        private

        def set_pagination
          @pagination = {
            current: @current_month,
            previous: @current_month - 1.month,
            next: @current_month + 1.month
          }
        end
      end
    end
  end
end
