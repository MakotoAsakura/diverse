# frozen_string_literal: true

module Admin
  class MypageController < AdminController
    include Base::BaseFilter
    include Base::CrudFilter
    include Base::LayoutFilter

    layout "admin/base"
    title_page "マイページ"
  end
end
