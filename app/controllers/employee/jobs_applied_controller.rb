# frozen_string_literal: true

module Employee
  class JobsAppliedController < EmployeeController
    include Base::BaseFilter
    include Base::CrudFilter

    layout "employee/base"
    model Job

    before_action :find_candidate_job_applied, only: %w[show]
    before_action :find_job, only: :create
    before_action :create_room_chat, only: :create
    before_action -> { flash.discard }, unless: -> { request.referrer&.include?("/jobs_applied") }

    def index
      @model = CandidateJob
      @items = @model.joins(:job, job: { medical_institution: :user }).where(candidate_id: current_candidate.id).where.not("jobs.status" => :draft)
      @q = @items.ransack(params[:q])
      @items = @q.result.page(params[:page]).per(10)
    end

    def show
      raise "404" unless @item.medical_institution.user

      super
    end

    def new
      redirect_to jobs_path if params[:job_id].blank?

      @candidate_job = current_candidate.candidate_jobs.new(job_id: params[:job_id])

      raise "404" unless @candidate_job.job.medical_institution.user

      redirect_to job_path(@candidate_job.job) unless @candidate_job.job.published?

      render params[:step] == "profile" ? "profile" : "new"
    end

    def create
      redirect_to job_path(@job) unless @job.published?
      raise "403" unless @job.medical_institution.user

      @candidate_job = current_candidate.candidate_jobs.find_or_create_by(job: @job)
      create_room_chat if @candidate_job.present?
      CandidateMailer.create_apply_job(@candidate_job, @room_chat).deliver_later
      MedicalInstitutionMailer.create_apply_job(@candidate_job).deliver_later
    end

    def recruitment
      set_item
      raise "404" unless @item.medical_institution.user

      find_candidate_job_applied

      @candidate_job_applied.generate_contract_id
      @candidate_job_applied.status = :recruitment
      @candidate_job_applied.save
      flash[:danger] = @candidate_job_applied.errors.full_messages.join if @candidate_job_applied.invalid?
      location = { action: :show }
      CandidateMailer.apply_job(@candidate_job_applied).deliver_later
      MedicalInstitutionMailer.apply_job(@candidate_job_applied).deliver_later

      respond_to do |format|
        format.html { redirect_to location }
        format.json { render json: @item.to_json, content_type: json_content_type }
      end
    end

    def decline
      set_item
      raise "404" unless @item.medical_institution.user

      find_candidate_job_applied

      @candidate_job_applied.decline!
      location = { action: :show }
      CandidateMailer.reject_job(@candidate_job_applied).deliver_later
      MedicalInstitutionMailer.reject_job(@candidate_job_applied).deliver_later

      respond_to do |format|
        format.html { redirect_to location }
        format.json { render json: @item.to_json, content_type: json_content_type }
      end
    end

    private

    def find_job
      @job = Job.find(params[:job_id])
    end

    def create_room_chat
      @room_chat = RoomChat.create_room(current_user.id, @job.medical_institution.user.id)
    end

    def find_candidate_job_applied
      @candidate_job_applied = @item.candidate_jobs.where(candidate_id: current_candidate.id).order(updated_at: :desc).first
      @candidate_job_applied.update(employee_read_at: Time.current)
    end
  end
end
