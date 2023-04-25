# frozen_string_literal: true

module Medical
  class JobsAppliedController < MedicalController
    include Base::BaseFilter
    include Base::CrudFilter

    before_action :disable_turbo, only: :index

    layout "medical/base"
    title_page I18n.t("medical.jobs.title.index")

    before_action :set_viewed_item, only: :show # rubocop:disable Rails/LexicallyScopedActionFilter

    model ::CandidateJob

    def index
      @q = @model.joins(job: :medical_institution).where(medical_institution: { id: current_medical.id })
                 .where.not("jobs.status": :draft).order(created_at: :desc).ransack(params[:q])

      @q.job_status_in = [Job.statuses[:published], Job.statuses[:ended]] unless params.dig(:q, :job_status_in)

      @items = @q.result.page(params[:page]).per(10)
      @items.map do |item|
        room_chat = RoomChat.find_room(current_user.id, item.candidate.user.id)
        item.employee_waiting_message = room_chat.present? && !room_chat.seen?(current_user)
      end
    end

    def confirm
      session[(controller_name + @model.name).to_sym] = find_params.merge({ status: "waiting" }) if params[:item].present?
      params[:id] ? set_item : @item = @model.new
      @item.attributes = session[(controller_name + @model.name).to_sym]

      render_confirm @item.valid?
    end

    def update
      @item.attributes = find_params.merge({ status: "waiting" })

      render_update @item.save
      MedicalInstitutionMailer.apply_candidate(@item).deliver_later
      CandidateMailer.apply_candidate(@item).deliver_later
    end

    def rejection
      set_item
    end

    def reject
      clear_session
      set_item

      @item.rejected!
      location = { action: :complete, target: :rejected }
      MedicalInstitutionMailer.reject_candidate(@item).deliver_later
      CandidateMailer.reject_candidate(@item).deliver_later

      respond_to do |format|
        format.html { redirect_to location }
        format.json { render json: @item.to_json, status: :created, content_type: json_content_type }
      end
    end

    private

    def set_viewed_item
      @item.view!
    end
  end
end
