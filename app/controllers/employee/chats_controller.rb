# frozen_string_literal: true

module Employee
  class ChatsController < EmployeeController
    skip_before_action :authenticate_user!, only: %i[update]
    before_action :set_room, only: %i[update mark_read show]
    before_action :update_read_at, only: :show
    before_action :create_token_firebase, only: :show
    before_action :messages_unseen

    def new; end

    def show
      raise "404" unless @room.medical_user
    end

    def index
      @rooms = RoomChat.available(current_user.id).order(sent_at: :desc).page(params[:page]).per(5)
    end

    def update
      @room.sent_at = Time.zone.now
      @room.update(update_params)
    end

    def mark_read
      @room.update(read_at: Time.zone.now)
    end

    private

    def update_params
      params.require(:room).permit(:last_message, :last_sender_id)
    end

    def update_read_at
      @room.update(read_at: Time.zone.now)
    end

    def set_room
      @room = RoomChat.find_by(room_code: params[:id])

      raise "404" unless @room
    end

    def create_token_firebase
      firebase_service = FirebaseService.new

      cookies[:firebase_token] = firebase_service.create_custom_token(current_user.id)
    end
  end
end
