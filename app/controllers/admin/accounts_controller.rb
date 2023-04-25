# frozen_string_literal: true

module Admin
  class AccountsController < AdminController
    include Base::BaseFilter
    include Base::CrudFilter
    include Base::LayoutFilter

    before_action :set_item, except: :complete
    before_action :set_title_page
    skip_before_action :authenticate_admin_user!, if: -> { action_name == "complete" && params[:_action] == "destroy" }

    layout "admin/base"
    model User

    def update
      clear_session
      @item.attributes = find_params
      is_changed_password = begin
        @item.encrypted_password_changed?
      rescue StandardError
        nil
      end

      if @item.save
        sign_in(@item, bypass: true)
        AdminMailer.update_manage(current_user, @item.manage).deliver_later
        # AdminMailer.update_password(current_user).deliver_later if is_changed_password
        redirect_to complete_admin_account_path(params: { _action: "edit" })
      else
        render "new" # rubocop:disable GitHub/RailsControllerRenderPathsExist
      end
    end

    def destroy
      flash.clear
      sign_out @item
      render_destroy @item, location: { action: :complete, params: { _action: "destroy" } }
    end

    def complete
      flash.clear
      super
    end

    private

    def set_item
      @item = @model.find(current_user.id)
    end
  end
end
