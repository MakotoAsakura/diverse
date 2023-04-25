# frozen_string_literal: true

module Medical
  class JobsController < MedicalController
    include Base::BaseFilter
    include Base::CrudFilter

    skip_before_action :verify_authenticity_token, only: :save_draft
    skip_before_action :authenticate_medical_user!, only: %i[new next_step] # rubocop:disable Rails/LexicallyScopedActionFilter

    layout "medical/base"
    title_page I18n.t("medical.jobs.title.index")
    model Job

    before_action :set_title_page

    def index
      @items = current_medical.jobs.order(created_at: :desc).search_for_medical(params[:s]).page(params[:page]).per(10)
    end

    def next_step
      session[(controller_name + @model.name).to_sym] = find_params if params[:item].present?

      params[:id] ? set_item : @item = @model.new
      @item.attributes = session[(controller_name + @model.name).to_sym]

      authenticate_medical_user!
      render_next_step @item.valid?
    end

    def create
      clear_session
      @item = @model.new find_params.merge({ status: "published" })
      render_create @item.save
    end

    def update
      @item.attributes = find_params.merge({ status: "published" })

      render_update @item.save
    end

    def save_draft
      params[:id] ? set_item : @item = @model.new

      if params[:commit]
        @item.attributes = find_params.merge({ status: "draft" })
        @item.skip_validate_presence = true

        if @item.save
          clear_session
          location = { action: :complete, target: :save_draft }

          respond_to do |format|
            format.html { redirect_to location }
          end
        else
          template_action = if @item.errors.key?(:open_at) || @item.errors.key?(:close_at)
                              { template: "next_step" }
                            else
                              @item.new_record? ? { template: "new" } : { template: "edit" }
                            end
          respond_to do |format|
            format.html { render template_action }
            format.json { render json: @item.errors.full_messages, status: :unprocessable_entity, content_type: json_content_type }
          end
        end
      else
        template_action = @item.new_record? ? { template: "new" } : { template: "edit" }
        respond_to do |format|
          format.html { render template_action }
          format.json { render json: @item.errors.full_messages, status: :unprocessable_entity, content_type: json_content_type }
        end
      end
    end

    def end_job
      clear_session
      set_item

      @item.status = "ended"
      @item.save(validate: false)
      location = { action: :complete, target: :end_job }

      respond_to do |format|
        format.html { redirect_to location }
        format.json { render json: @item.to_json, status: :created, content_type: json_content_type }
      end
    end

    def complete
      self.class.send(:title_page, I18n.t("medical.jobs.title.complete.#{params[:target]}")) if params[:target]

      super
    end

    private

    def render_next_step(result, opts = {})
      unless result
        @item.errors.delete(:open_at) if @item.errors.key?(:open_at)
        @item.errors.delete(:close_at) if @item.errors.key?(:close_at)
      end

      template_action = @item.new_record? ? { template: "new" } : { template: "edit" }
      render_opts = opts[:render].presence || template_action

      if @item.errors.blank?
        respond_to do |format|
          format.html { { template: "next_step" } }
        end
      else
        respond_to do |format|
          format.html { render render_opts }
          format.json { render json: @item.errors.full_messages, status: :unprocessable_entity, content_type: json_content_type }
        end
      end
    end

    def render_confirm(result, opts = {})
      render_opts = opts[:render].presence || { template: "next_step" }

      if result
        respond_to do |format|
          format.html { render }
        end
      else
        respond_to do |format|
          format.html { render render_opts }
          format.json { render json: @item.errors.full_messages, status: :unprocessable_entity, content_type: json_content_type }
        end
      end
    end

    def fix_params
      { medical_institution_id: current_medical&.id }
    end
  end
end
