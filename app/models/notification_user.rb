# frozen_string_literal: true

class NotificationUser < ApplicationRecord
  belongs_to :notification
  belongs_to :user
end
