# frozen_string_literal: true

module Admin
  class UsersController < AdminController
    include Base::BaseFilter
    include Base::CrudFilter
    include Base::LayoutFilter

    layout "admin/base"
    title_page I18n.t("admin.users.title")
    model User

    before_action :set_title_page
    before_action :fix_params, only: :create # rubocop:disable Rails/LexicallyScopedActionFilter

    private

    def fix_params
      { role: @model.roles[:admin] }
    end
  end
end
