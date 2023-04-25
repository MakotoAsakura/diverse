# frozen_string_literal: true

class RoomChat < ApplicationRecord
  require "securerandom"

  belongs_to :first_user, -> { unscope(where: User.discard_column) }, class_name: "User"
  belongs_to :second_user, -> { unscope(where: User.discard_column) }, class_name: "User"

  before_create :generate_room_code

  scope :used, -> { where.not(last_message: nil) }
  scope :first_user_available, ->(current_user_id) { used.where(first_user_id: current_user_id) }
  scope :second_user_available, ->(current_user_id) { used.where(second_user_id: current_user_id) }
  scope :available, lambda { |current_user_id| # Get room_chat that both users still exist
    first_user_available(current_user_id).or(RoomChat.second_user_available(current_user_id))
                                         .where.not(last_sender_id: nil).joins(:first_user, :second_user)
  }
  scope :unseen, lambda { |current_user_id|
    joins(:first_user, :second_user)
      .where.not(last_sender_id: current_user_id)
      .and(RoomChat.where("sent_at > read_at").or(RoomChat.where(read_at: nil).where.not(last_message: nil)))
      .and(RoomChat.available(current_user_id))
  }

  scope :medical_unseen, lambda { |current_user_id|
    joins(:first_user, :second_user)
      .where.not(last_sender_id: current_user_id)
      .and(RoomChat.where("sent_at > medical_read_at").or(RoomChat.where(medical_read_at: nil).where.not(last_message: nil)))
      .and(RoomChat.available(current_user_id))
  }

  def seen?(current_user)
    return true if current_user.id == last_sender_id

    if current_user.user?
      check_read(read_at)
    else
      check_read(medical_read_at)
    end
  end

  def check_read(time_read)
    if sent_at.present? && time_read.nil?
      false
    elsif sent_at.nil?
      true
    else
      sent_at < time_read
    end
  end

  def medical_user
    first_user&.medical_institution.presence || second_user&.medical_institution
  end
  class << self
    def create_room(first_user_id, second_user_id)
      room_exist = find_room(first_user_id, second_user_id)
      return room_exist if room_exist.present?

      RoomChat.create(first_user_id: first_user_id, second_user_id: second_user_id)
    end

    def find_room(first_user_id, second_user_id)
      RoomChat.find_by(first_user_id: first_user_id, second_user_id: second_user_id) || RoomChat.find_by(first_user_id: second_user_id, second_user_id: first_user_id)
    end
  end

  def candidate_user
    first_user.candidate.presence || second_user.candidate
  end

  private

  def generate_room_code
    random = SecureRandom.hex(3)

    if self.class.exists?(room_code: random)
      generate_room_code
    else
      self.room_code = random
    end
  end
end
