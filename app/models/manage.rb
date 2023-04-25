# frozen_string_literal: true

class Manage < ApplicationRecord
  include Base::PermitParams
  include Base::Scope::Base
  include Base::Document
  include ManageDecorator

  belongs_to :user, class_name: "User"

  accepts_nested_attributes_for :user, update_only: true, allow_destroy: true

  permit_params :first_name, :last_name,
                user_attributes: %i[email email_confirmation password password_confirmation role]

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }

  scope :created_at_desc, -> { order(created_at: :desc) }

  delegate :email, :password, :password_confirmation, to: :user, prefix: true, allow_nil: true

  # custom ransacker
  ransacker :full_name do |parent|
    Arel::Nodes::NamedFunction.new("CONCAT_WS", [
                                     Arel::Nodes.build_quoted(" "), parent.table[:first_name], parent.table[:last_name]
                                   ])
  end

  class << self
    def search(params)
      search_name(params).search_email(params)
    end

    def search_name(params)
      return all if params.blank? || params[:name].blank?

      where("CONCAT_WS(' ', first_name, last_name) LIKE ?", "%#{params[:name]}%")
    end

    def search_email(params)
      return all if params.blank? || params[:email].blank?

      all.joins(:user).where("users.email like ?", "%#{params[:email]}%")
    end
  end
end
