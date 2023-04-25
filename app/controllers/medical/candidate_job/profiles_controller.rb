# frozen_string_literal: true

module Medical
  module CandidateJob
    class ProfilesController < MedicalController
      include Base::BaseFilter
      include Base::CrudFilter

      layout "medical/base"
      model ::CandidateJob

      private

      def set_item
        @item = @model.find(params[:candidate_job_id])
      end
    end
  end
end
