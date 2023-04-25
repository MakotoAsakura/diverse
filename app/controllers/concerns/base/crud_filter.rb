# frozen_string_literal: true

module Base
  module CrudFilter
    extend ActiveSupport::Concern

    included do
      before_action :prepend_current_view_path
      before_action :append_view_paths
      before_action :set_item, only: %i[show edit update delete destroy confirm_delete]
    end

    def index
      @items = @model.order(id: :desc).page(params[:page]).per(100)

      render
    end

    def show
      render
    end

    def new
      if params[:type] == "back"
        @item = @model.new pre_params.merge(session[(controller_name + @model.name).to_sym] || fix_params)
      else
        clear_session
        @item = @model.new pre_params.merge(fix_params)
      end

      render
    end

    def confirm
      session[(controller_name + @model.name).to_sym] = find_params if params[:item].present?
      params[:id] ? set_item : @item = @model.new
      @item.attributes = session[(controller_name + @model.name).to_sym]

      render_confirm @item.valid?
    end

    def create
      clear_session
      @item = @model.new find_params
      render_create @item.save
    end

    def edit
      if params[:type] == "back"
        @item.attributes = session[(controller_name + @model.name).to_sym]
      else
        clear_session
      end

      render
    end

    def update
      @item.attributes = find_params

      render_update @item.save
    end

    def confirm_delete
      render
    end

    def delete
      render
    end

    def destroy
      render_destroy @item.destroy
    end

    def complete
      render
    end

    private

    def prepend_current_view_path
      prepend_view_path "app/views/#{params[:controller]}"
    end

    def append_view_paths
      append_view_path "app/views/base/crud"
    end

    def render(*args)
      args.empty? ? super(template: params[:action]) : super
    end

    def fix_params
      {}
    end

    def pre_params
      {}
    end

    def permit_fields
      @model.permitted_fields
    end

    def find_params
      params.require(:item).permit(permit_fields).merge(fix_params)
    rescue StandardError
      raise "400"
    end

    def crud_redirect_url
      nil
    end

    def set_item
      @item ||= begin
        item = @model.find(params[:id])
        item.attributes = fix_params
        item
      end
    rescue StandardError => e
      return render_destroy(true) if params[:action] == "destroy"

      raise e
    end

    def render_create(result, opts = {})
      location = opts[:location].presence || crud_redirect_url || { action: :complete, params: { _action: "new" } }
      render_opts = opts[:render].presence || { template: "new" }
      notice = opts[:notice].presence || "notice.save"

      if result
        respond_to do |format|
          format.html { redirect_to location, notice: notice }
          format.json { render json: @item.to_json, status: :created, content_type: json_content_type }
        end
      else
        respond_to do |format|
          format.html { render render_opts }
          format.json { render json: @item.errors.full_messages, status: :unprocessable_entity, content_type: json_content_type }
        end
      end
    end

    def render_destroy(result, opts = {})
      location = opts[:location].presence || crud_redirect_url || { action: :complete, params: { _action: "destroy" } }
      render_opts = opts[:render].presence || { template: "delete" }
      notice = opts[:notice].presence || "notice.deleted"

      if result
        respond_to do |format|
          format.html { redirect_to location, notice: notice }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { render render_opts }
          format.json { render json: @item.errors.full_messages, status: :unprocessable_entity }
        end
      end
    end

    def render_update(result, opts = {})
      location = opts[:location].presence || crud_redirect_url || { action: :complete, params: { _action: "edit" } }
      render_opts = opts[:render].presence || { template: "edit" }
      notice = opts[:notice].presence || "notice.saved"

      if result
        respond_to do |format|
          format.html { redirect_to location, notice: notice }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { render render_opts }
          format.json { render json: @item.errors.full_messages, status: :unprocessable_entity, content_type: json_content_type }
        end
      end
    end

    def render_confirm(result, opts = {})
      render_opts = opts[:render].presence || { template: @item.new_record? ? "new" : "edit" }

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

    def clear_session
      session.delete((controller_name + @model.name).to_sym) if session[(controller_name + @model.name).to_sym]
    end
  end
end
