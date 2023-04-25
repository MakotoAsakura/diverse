# frozen_string_literal: true

module Medical
  class AttendancesController < MedicalController
    before_action :set_attendance, only: %i[show update]
    before_action :set_candidate_job, only: %i[index]
    skip_before_action :verify_authenticity_token, only: %i[update]

    include Base::BaseFilter
    include Base::CrudFilter

    layout "medical/base"
    model ::Attendance
    def index
      @year = params[:year].presence || Date.current.year
      @month = params[:month].presence || Date.current.month
      @month_select = params[:month].present? ? Date.parse("#{params[:year]}/#{params[:month]}/01") : Date.current
      candidate_job = ::CandidateJob.find(params[:candidate_job_id])
      @job = Job.find(candidate_job.job_id)
      @items = Attendance.sent_request.in_month("#{@year}-#{@month}")
                         .by_candidate_job(current_medical.id, candidate_job.candidate_id, candidate_job.job_id)
                         .index_by do |attendance|
        attendance.checkin.to_date.to_s
      end
    end

    def show
      respond_to do |format|
        format.json { render json: json_response, status: :ok }
      end
    end

    def update
      if update_params[:status] == "approved"
        @attendance.update(status: update_params[:status])
      else
        @attendance.update(update_params)
      end

      redirect_to request.referrer
    end

    private

    def update_params
      params.require(:attendance).permit(:status, :reject_note)
    end

    def set_attendance
      @attendance = Attendance.find_by(id: params[:id])
    end

    def set_candidate_job
      @candidate_job = ::CandidateJob.find_by(id: params[:candidate_job_id])
    end

    def json_response
      {
        attendance_date: @attendance.checkin.strftime("%m/%d"),
        checkin_time: @attendance.checkin.strftime("%H:%M"),
        checkout_time: @attendance.checkout.strftime("%H:%M"),
        start_break_time1: @attendance.shift_1_checkin&.strftime("%H:%M"),
        end_break_time1: @attendance.shift_1_checkout&.strftime("%H:%M"),
        start_break_time2: @attendance.shift_2_checkin&.strftime("%H:%M"),
        end_break_time2: @attendance.shift_2_checkout&.strftime("%H:%M"),
        note: @attendance.note,
        reject_note: @attendance.reject_note
      }
    end
  end
end
