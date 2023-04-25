# frozen_string_literal: true

module Medical
  class AccountsController < MedicalController
    include Base::BaseFilter
    include Base::CrudFilter

    before_action :set_item, except: %i[complete delete_complete] # rubocop:disable Rails/LexicallyScopedActionFilter
    skip_before_action :authenticate_medical_user!, only: %i[delete_complete]

    layout "medical/base"
    model User

    def update
      clear_session

      if @user.update(update_params)
        bypass_sign_in(@user, scope: :medical_user)
        MedicalInstitutionMailer.account_update(@item).deliver_later
        redirect_to complete_medical_account_path
      else
        render "new" # rubocop:disable GitHub/RailsControllerRenderPathsExist
      end
    end

    def confirm
      session[:update_medical_params] = update_params if params[:user].present?

      @user.attributes = session[:update_medical_params]

      if @user.valid?
        respond_to do |format|
          format.html { render }
        end
      else
        render "edit" # rubocop:disable GitHub/RailsControllerRenderPathsExist
      end
    end

    def destroy
      User.transaction do
        if @user.discard
          redirect_to delete_complete_medical_account_path
        else
          redirect_to confirm_delete_medical_account_path
        end
      end
    end

    def delete_complete; end

    private

    def set_item
      @user = User.find(current_user.id)
    end

    def update_params
      params.require(:user).permit(
        :password, :password_confirmation, :email,
        medical_institution_attributes: [:name, :name_kana, :phone_number, :url, :zipcode_first,
                                         :zipcode_last, :location, :first_name_manager, :last_name_manager,
                                         :first_name_kana_manager, :last_name_kana_manager,
                                         { pharmaceutical_company_attributes: %i[name staff_ms] }]
      )
    end
  end
end
