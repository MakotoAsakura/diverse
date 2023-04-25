# frozen_string_literal: true

module Employee
  class NotificationsController < EmployeeController
    before_action :disable_turbo, only: :index

    before_action -> { @model = Notification }

    def index
      @q = @model.joins("LEFT OUTER JOIN notification_users ON notification_users.notification_id = notifications.id AND notification_users.user_id = #{current_user.id}")
                 .select("notifications.*, IF(notification_users.read_at, 1, NULL) AS `read`")
                 .opening.order(:start_time).distinct.ransack(params[:q])
      if @q.end_time_lteq && @q.start_time_gteq && @q.start_time_gteq > @q.end_time_lteq
        @invalid_message = t(".time_invalid")
        @items = []
        return
      end

      @items = @q.result.page(params[:page]).per(5)
    end

    def show
      @item = @model.opening.find(params[:id])
      @item.read_by_user(current_user)
    end
  end
end
