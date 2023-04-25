# frozen_string_literal: true

module Admin
  class NotificationsController < AdminController
    include Base::BaseFilter
    include Base::CrudFilter
    include Base::LayoutFilter

    layout "admin/base"
    model Notification

    before_action :set_title_page
    after_action -> { flash.discard }, only: %i[create update destroy]

    def index
      @q = @model.order(:start_time).ransack(params[:q])

      if @q.end_time_lteq && @q.start_time_gteq && @q.start_time_gteq > @q.end_time_lteq
        @invalid_message = t(".time_invalid")
        @items = []
        return
      end

      @items = @q.result.page(params[:page]).per(10)
    end

    def edit
      if params[:type] == "back"
        @file_ids = session["#{(controller_name + @model.name).to_sym}_file_ids"]
        @item.attributes = session[(controller_name + @model.name).to_sym]
      else
        @file_ids = @item.attachments.pluck(:id)
        clear_session
      end

      render
    end

    def confirm
      session[(controller_name + @model.name).to_sym] = find_params if params[:item].present?
      set_item
      @item.attributes = session[(controller_name + @model.name).to_sym]

      @file_ids = upload_file_ids
      session["#{(controller_name + @model.name).to_sym}_file_ids"] = @file_ids

      render_confirm @item.valid?
    end

    def create
      @item = @model.new
      @item.attributes = find_params
      set_file_owner

      render_create @item.save
    end

    def update
      set_file_owner

      @item.attributes = find_params

      render_update @item.save, location: { action: :complete, params: { _action: "edit" } }
    end

    def confirm_delete
      self.class.send(:title_page, t("admin.notifications.title.confirm_delete"))

      super
    end

    def destroy
      render_destroy @item.destroy, location: { action: :complete, params: { _action: "destroy" } }
    end

    def complete
      self.class.send(:title_page, t("admin.notifications.complete.#{params[:_action].presence || 'new'}.title"))

      super
    end

    private

    def set_item
      @item = params[:id].present? ? @model.find(params[:id]) : @model.new
    end

    def fix_params
      if params[:action] && @group_action_new.include?(params[:action])
        super.merge({ creator_id: current_user.id })
      else
        super
      end
    end

    def set_file_owner
      return unless params[:file_ids]

      Attachment.where(id: @item.attachment_ids - params[:file_ids].map(&:to_i)).destroy_all
      @item.attachments = Attachment.where(id: params[:file_ids])
    end

    def upload_file_ids
      session_file_ids = session["#{(controller_name + @model.name).to_sym}_file_ids"]
      ids = []

      ids = params[:file_ids].map(&:to_i) if params[:file_ids].present?
      ids += session_file_ids.map(&:to_i) if session_file_ids.present?

      if params[:file].present?
        params[:file].each do |file|
          attachment = Attachment.new(file: file)
          # remove invalid file
          attachment.valid?(:document_and_image) && attachment.save!
          ids << attachment.id.to_i
        end
      end

      ids.uniq!
      ids -= params[:file_remove_ids].map(&:to_i) if params[:file_remove_ids]

      ids
    end

    def clear_session
      session.delete((controller_name + @model.name).to_sym) if session[(controller_name + @model.name).to_sym]
      session.delete("#{(controller_name + @model.name).to_sym}_file_ids") if session["#{(controller_name + @model.name).to_sym}_file_ids"]
    end
  end
end
