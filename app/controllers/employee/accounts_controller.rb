# frozen_string_literal: true

module Employee
  class AccountsController < EmployeeController
    include Base::BaseFilter
    include Base::CrudFilter

    before_action :set_item, except: %i[complete delete_complete] # rubocop:disable Rails/LexicallyScopedActionFilter
    skip_before_action :authenticate_user!, only: %i[delete_complete]

    layout "employee/base"
    model User

    def update
      clear_session
      @item.attributes = find_params
      @item.candidate.dob = "#{find_params[:candidate_attributes][:year_of_birth]}/#{find_params[:candidate_attributes][:month_of_birth]}/#{find_params[:candidate_attributes][:day_of_birth]}"
      is_changed_password = begin
        @item.encrypted_password_changed?
      rescue StandardError
        nil
      end

      if @item.save
        bypass_sign_in(@item, scope: :user)
        CandidateMailer.account_update(@item.candidate).deliver_later
        # CandidateMailer.update_password(@item.candidate).deliver_later if is_changed_password
        redirect_to complete_account_path
      else
        render "edit" # rubocop:disable GitHub/RailsControllerRenderPathsExist
      end
    end

    def destroy
      User.transaction do
        @item.update delete_params
        if @item.discard
          CandidateMailer.account_destroy(@item.full_name, @item.email).deliver_later
          redirect_to delete_complete_account_path
        else
          redirect_to confirm_delete_account_path
        end
      end
    end

    def delete_complete; end

    private

    def set_item
      @item = User.find(current_user.id)
    end

    def find_params
      params_permit = params.require(:item).permit(permit_fields)

      params_permit[:candidate_attributes][:dob] = "#{params_permit[:year_of_birth]}/#{params_permit[:month_of_birth]}/#{params_permit[:day_of_birth]}"
      params_permit.to_h.deep_merge(fix_params)
    end

    def delete_params
      params_permit = params.require(:item).permit(permit_fields)

      params_permit.to_h.deep_merge(fix_params)
    end
  end
end
