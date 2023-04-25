# frozen_string_literal: true

module Admin
  class ManagesController < AdminController
    include Base::BaseFilter
    include Base::CrudFilter
    include Base::LayoutFilter

    layout "admin/base"
    title_page I18n.t("admin.manages.title")
    model Manage

    before_action :set_title_page
    after_action :send_mail, only: %i[create update destroy] # rubocop:disable Rails/LexicallyScopedActionFilter

    def index
      @items = @model.created_at_desc.search(params[:s]).page(params[:page]).per(10)
    end

    def complete
      flash.clear
      render
    end

    private

    def send_mail
      case action_name
      when "create"
        AdminMailer.send("#{action_name}_manage", current_user, @item, @item.user.password).deliver_later
      when "destroy"
        AdminMailer.send("#{action_name}_manage", current_user, @item.full_name, @item.user_email).deliver_later
      else
        AdminMailer.send("#{action_name}_manage", current_user, @item).deliver_later
      end
    end
  end
end
