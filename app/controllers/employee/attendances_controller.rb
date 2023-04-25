# frozen_string_literal: true

module Employee
  class AttendancesController < EmployeeController
    before_action :set_attendance, only: %i[edit update show submit cancel]
    before_action :set_date, only: %i[edit update show]

    # some screen dont have flash
    before_action -> { flash.discard }, unless: -> { request.referrer&.include?("/attendances") }

    def index
      if params[:medical_institution_id].blank? && params[:job_id].blank?
        @medical_institutions =
          current_candidate.medical_institutions
                           .left_outer_joins(:attendances)
                           .select("medical_institutions.*, count(case when attendances.status = 3 then 1 else null end) AS notification_count")
                           .group(:id)
                           .page(params[:page]).per(10)
        return
      end

      if params[:medical_institution_id].present?
        @medical_institution = current_candidate.medical_institutions.find(params[:medical_institution_id])

        if params[:job_id].blank?
          @candidate_jobs =
            current_candidate.candidate_jobs.joins(job: :medical_institution).where(medical_institution: { id: @medical_institution.id }).recruitment
                             .select("candidate_jobs.*, count(case when attendances.status = 3 then 1 else null end) AS notification_count")
                             .left_outer_joins(job: :attendances)
                             .group(:id)
                             .order(created_at: :desc)
                             .page(params[:page]).per(10)
          render "jobs" # rubocop:disable GitHub/RailsControllerRenderPathsExist
          return
        end
      end

      return if params[:job_id].blank?

      @job = current_candidate.job_workings.select("jobs.*, candidate_jobs.contract_start_at, candidate_jobs.contract_end_at, candidate_jobs.contract_id").find(params[:job_id])
      @current_month = params[:month].present? ? Date.parse("#{params[:month]}-01") : Date.current
      @attendances = current_candidate.attendances.where(job_id: @job.id).in_month(@current_month).index_by do |attendance|
        attendance.checkin.to_date.to_s
      end

      set_pagination
      render "attendances" # rubocop:disable GitHub/RailsControllerRenderPathsExist
    end

    def new
      @job = current_candidate.job_workings.find(params[:job_id])
      raise "404" unless @job.medical_institution.user

      @date = Date.parse(params[:date])
      @attendance = current_candidate.attendances.new(job_id: @job.id, medical_institution_id: @job.medical_institution_id)
    end

    def create
      @job = current_candidate.job_workings.find(params[:job_id])
      raise "404" unless @job.medical_institution.user

      @date = Date.parse(params[:date])
      @attendance = current_candidate.attendances.in_day(@date).find_or_initialize_by(job_id: @job.id, medical_institution_id: @job.medical_institution_id)
      @attendance.assign_attributes(attendance_params)
      if @attendance.save
        flash[:success] = t(".success")
        redirect_to attendances_path(params: { job_id: @job.id })
      else
        render "new" # rubocop:disable GitHub/RailsControllerRenderPathsExist
      end
    end

    def edit; end

    def update
      raise "404" unless @attendance.medical_institution.user

      if @attendance.waiting?
        redirect_to attendances_path(params: { job_id: @attendance.job_id })
        return
      end

      if @attendance.update(attendance_params)
        flash[:success] = t(".success")
        redirect_to attendances_path(params: { job_id: @attendance.job_id })
      else
        render "edit" # rubocop:disable GitHub/RailsControllerRenderPathsExist
      end
    end

    def show; end

    def submit
      raise "404" unless @attendance.medical_institution.user

      @attendance.waiting! if @attendance.review? || @attendance.rejected?
      flash[:success] = t(".success")
      redirect_to attendances_path(params: { job_id: @attendance.job_id })
    end

    def cancel
      raise "404" unless @attendance.medical_institution.user

      @attendance.review! if @attendance.waiting?
      flash[:success] = t(".success")
      redirect_to attendances_path(params: { job_id: @attendance.job_id })
    end

    private

    def set_attendance
      @attendance = current_candidate.attendances.find(params[:id])
    end

    def set_date
      @date = @attendance.checkin.to_date
    end

    def set_pagination
      @pagination = {
        current: @current_month,
        previous: @current_month - 1.month,
        next: @current_month + 1.month
      }
    end

    def attendance_params
      params.require(:attendance).permit(:checkin_date, :checkin_time, :checkout_date, :checkout_time,
                                         :shift_1_checkin_date, :shift_1_checkin_time,
                                         :shift_1_checkout_date, :shift_1_checkout_time,
                                         :shift_2_checkin_date, :shift_2_checkin_time,
                                         :shift_2_checkout_date, :shift_2_checkout_time,
                                         :transportation_fee, :note)
    end
  end
end
