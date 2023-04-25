# frozen_string_literal: true

module Admin
  module CandidateJob
    class ContractsController < AdminController
      include Base::BaseFilter
      include Base::CrudFilter

      layout "admin/base"
      model ::CandidateJob

      private

      def set_item
        @item = @model.find(params[:candidate_job_id])
      end
    end
  end
end
