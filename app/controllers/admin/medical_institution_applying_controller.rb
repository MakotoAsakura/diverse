# frozen_string_literal: true

module Admin
  class MedicalInstitutionApplyingController < AdminController
    include Base::BaseFilter
    include Base::CrudFilter
    include Base::LayoutFilter

    layout "admin/base"

    model MedicalInstitution

    before_action :set_title_page
    before_action :set_item, except: %i[index show]

    def index
      @items = @model.joins(:user).self_registration.search_medical_institution_applying(params[:s]).created_at_desc.page(params[:page]).per(10)
    end

    def show
      @item = @model.includes(%i[user pharmaceutical_company]).find(params[:id])
      checked_view_medical
    end

    def complete_approval
      if params[:approve] == "true"
        @item.assign_attributes(approved_date: Time.zone.now, status: MedicalInstitution.statuses[:approved])
      else
        @item.assign_attributes(approved_date: Time.zone.now,
                                status: MedicalInstitution.statuses[:rejected],
                                reason: params[:reason])
      end

      @item.save
      AdminMailer.complete_approval(Manage.joins(:user).pluck(:email), @item).deliver_later
      MedicalInstitutionMailer.complete_approval(@item).deliver_later
    end

    def confirm_approve; end

    def confirm_rejection; end

    private

    def checked_view_medical
      return @viewed = false if @item.viewed_date?

      @viewed = true
      @item.assign_attributes(viewed_date: Time.zone.now)
      @item.save
    end
  end
end
