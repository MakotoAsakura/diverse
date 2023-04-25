# frozen_string_literal: true

module Medical
  class ChatsController < MedicalController
    skip_before_action :verify_authenticity_token, only: :mark_read
    before_action :create_room, only: :show
    before_action :create_token_firebase, only: :show
    before_action :find_room, only: :mark_read

    include Base::BaseFilter

    layout "medical/base"

    def new; end

    def index; end

    def show; end

    def mark_read
      @room.update(medical_read_at: Time.zone.now)
    end

    private

    def find_room
      @room = RoomChat.find_by(room_code: params[:id])
    end

    def create_room
      @room = if room_exist?
                RoomChat.find_by(first_user_id: current_user.id, second_user_id: params[:id]) || RoomChat.find_by(first_user_id: params[:id], second_user_id: current_user.id)
              else
                RoomChat.create(first_user_id: current_user.id, second_user_id: params[:id])
              end
    end

    def room_exist?
      RoomChat.exists?(first_user_id: current_user.id, second_user_id: params[:id]) || RoomChat.exists?(first_user_id: params[:id], second_user_id: current_user.id)
    end

    def create_token_firebase
      firebase_service = FirebaseService.new

      cookies[:firebase_token] = firebase_service.create_custom_token(current_user.id)
    end
  end
end
