# frozen_string_literal: true

module Medical
  module CandidateJob
    class ContractsController < MedicalController
      include Base::BaseFilter
      include Base::CrudFilter

      layout "medical/base"
      model ::CandidateJob

      def edit
        if params[:type] == "back"
          @file_ids = session["#{(controller_name + @model.name).to_sym}_file_ids"]
          @item.attributes = session[(controller_name + @model.name).to_sym]
        else
          @file_ids = @item.attachments.pluck(:id)
          clear_session
        end

        render
      end

      def confirm
        session[(controller_name + @model.name).to_sym] = find_params if params[:item].present?
        set_item
        @item.attributes = session[(controller_name + @model.name).to_sym]

        @file_ids = upload_file_ids
        session["#{(controller_name + @model.name).to_sym}_file_ids"] = @file_ids

        render_confirm @item.valid?
      end

      def update
        raise "404" if @item.candidate.user.discarded?

        set_file_owner

        @item.attributes = find_params

        render_update @item.save
        MedicalInstitutionMailer.contact_updated(@item).deliver
        CandidateMailer.contact_updated(@item).deliver
      end

      private

      def set_item
        @item = @model.find(params[:candidate_job_id])
      end

      def set_file_owner
        return unless params[:file_ids]

        Attachment.where(id: @item.attachment_ids - params[:file_ids].map(&:to_i)).destroy_all
        @item.attachments = Attachment.where(id: params[:file_ids])
      end

      def upload_file_ids
        session_file_ids = session["#{(controller_name + @model.name).to_sym}_file_ids"]
        ids = []

        ids = params[:file_ids].map(&:to_i) if params[:file_ids].present?
        ids += session_file_ids.map(&:to_i) if session_file_ids.present?

        if params[:file].present?
          params[:file].each do |file|
            attachment = Attachment.create(file: file)
            ids << attachment.id.to_i
          end
        end

        ids.uniq!
        ids -= params[:file_remove_ids].map(&:to_i) if params[:file_remove_ids]

        ids
      end

      def clear_session
        session.delete((controller_name + @model.name).to_sym) if session[(controller_name + @model.name).to_sym]
        session.delete("#{(controller_name + @model.name).to_sym}_file_ids") if session["#{(controller_name + @model.name).to_sym}_file_ids"]
      end
    end
  end
end
