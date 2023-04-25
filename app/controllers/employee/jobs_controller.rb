# frozen_string_literal: true

module Employee
  class JobsController < EmployeeController
    skip_before_action :authenticate_user!, only: %w[index show]
    after_action -> { flash.discard }, only: :index

    def index
      @q = Job.opening.ransack(params[:q])
      if @q.end_at_gt && @q.start_at_lt && @q.end_at_gt > @q.start_at_lt
        @invalid_message = t(".time_invalid")
        return
      end

      @jobs = @q.result.page(params[:page]).per(5) if params[:q]
    end

    def show
      current_time = Time.current
      @job = Job.where(open_at: ..current_time, close_at: current_time..).where.not(status: %i[draft unpublished]).find(params[:id])
    end
  end
end
