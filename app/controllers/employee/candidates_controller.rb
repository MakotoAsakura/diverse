# frozen_string_literal: true

module Employee
  class CandidatesController < EmployeeController
    skip_before_action :authenticate_user!
    include Base::BaseFilter
    include Base::CrudFilter

    layout "employee/base"
    model Candidate

    private

    def fix_params
      if params[:action] && @group_action_new.include?(params[:action])
        { user_attributes: { role: "user" } }
      else
        super
      end
    end

    def find_params
      params_permit = params.require(:item).permit(permit_fields)

      params_permit[:dob] = "#{params_permit[:year_of_birth]}/#{params_permit[:month_of_birth]}/#{params_permit[:day_of_birth]}"
      params_permit.to_h.deep_merge(fix_params)
    end
  end
end
