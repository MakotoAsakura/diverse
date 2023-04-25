# frozen_string_literal: true

class Invoice < ApplicationRecord
  include Base::Scope::Base

  belongs_to :medical_institution

  before_create :generate_code

  private

  def generate_code
    count_id = Invoice.count + 1
    self.code = "#{SystemSetting.last.current_settlement_date.strftime('%Y%m%d')}-#{count_id.to_s.rjust(5, '0')[-5..]}"
  end
end
