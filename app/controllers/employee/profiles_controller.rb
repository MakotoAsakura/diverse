# frozen_string_literal: true

module Employee
  class ProfilesController < EmployeeController
    include Base::BaseFilter
    include Base::CrudFilter
    include Base::LayoutFilter

    layout "employee/base"
    model Candidate

    before_action :set_item, only: %w[show edit update] # rubocop:disable Rails/LexicallyScopedActionFilter

    def show
      if params[:ref].present? && params[:ref].include?("jobs_applied/new")
        job_id = params[:ref].match(/job_id=(\d+)/)[1]
        redirect_to new_jobs_applied_path(params: { job_id: job_id, step: "profile" })
        return
      end
      super
    end

    def update
      if params[:ref].present? && params[:ref].include?("jobs_applied/new")
        # apply job
        @item.assign_attributes(profile_update_params)
        if @item.valid?(:apply_job) && @item.save
          redirect_to params[:ref].presence || complete_profile_path
        else
          job_id = params[:ref].match(/job_id=(\d+)/)[1]
          @candidate_job = current_candidate.candidate_jobs.new(job_id: job_id)
          render "employee/jobs_applied/profile"
        end
      elsif @item.update(profile_update_params)
        # update profile
        redirect_to complete_profile_path
      else
        render "edit"  # rubocop:disable GitHub/RailsControllerRenderPathsExist
      end
    end

    private

    def profile_update_params
      params.require(:candidate).permit(
        :national, :gender, :experiences, :diplomas, :zipcode, :dob, :first_name, :last_name,
        :first_name_kana, :last_name_kana, :year_of_birth, :month_of_birth, :day_of_birth,
        :prefecture, :city, :address, :phone_number, :graduation_year, :skill,
        :specialization, :other_certificates, { attachments_attributes: %i[id description file _destroy] },
        { profiles_attributes: %i[id year_start_work month_start_work note year_end_work month_end_work _destroy] },
        { certificates: [] }
      )
    end

    def set_item
      @item = current_candidate
    end
  end
end
