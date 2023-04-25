# frozen_string_literal: true

module Employee
  class FaqsController < EmployeeController
    include Base::BaseFilter
    include Base::CrudFilter

    layout "employee/base"
    skip_before_action :authenticate_user!, only: %i[index show] # rubocop:disable Rails/LexicallyScopedActionFilter

    before_action :set_item, only: :show # rubocop:disable Rails/LexicallyScopedActionFilter

    def index
      return unless params[:category]

      @category = params[:category]
      @items = global_faqs[@category.to_sym]
      @items = @items.select { |faq| faq[:question].include?(params[:keyword]) } if params[:keyword]
    end

    private

    def set_item
      @category = params[:category]
      faq = Rails.root.join("public/faqs/#{@category}/#{params[:id]}.md")
      @item = { question: File.read(faq).lines.first[2..], answer: File.readlines(faq)[1..].join }
    end

    def global_faqs
      @@global_faqs ||= { # rubocop:disable Style/ClassVars
        medical: Dir.glob("public/faqs/medical/**/*.md").reject { |file| file.include?("medical_url") }.map { |faq| { question: File.read(faq).lines.first[2..], id: File.basename(faq, ".md") } },
        employee: Dir.glob("public/faqs/employee/**/*.md").reject { |file| file.include?("medical_url") }.map { |faq| { question: File.read(faq).lines.first[2..], id: File.basename(faq, ".md") } }
      }
    end
  end
end
