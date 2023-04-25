# frozen_string_literal: true

class TaxWithholding < ApplicationRecord
  include Base::PermitParams
  include Base::Document

  permit_params :from, :to, :tax, :kind, :formula_data

  enum kind: { normal: 0, formula: 1 }

  scope :from_asc, -> { order(from: :asc) }
  scope :in_range, lambda { |from, to|
    where("`from` >= :from AND `from` < :to OR `to` > :from AND `to` <= :to OR `from` < :from AND `to` > :to", from: from, to: to)
  }
  scope :exclude_self, ->(id) { where.not(id: id) }
  scope :with_kind, ->(kind) { where(kind: kind) }

  alias_attribute :formula_data, :tax

  validates :from, numericality: true
  validates :to, numericality: true
  validates :tax, presence: true, if: :normal?
  validates :formula_data, presence: true, if: :formula?
  validate :to_greater_than_from
  validate :cannot_overlap_another
  validate :formula_is_validate, if: :formula?

  class << self
    def import_file(file)
      spreadsheet = Roo::Spreadsheet.open file
      header = %w[from to tax kind]
      tax_withholdings = []
      (1..spreadsheet.last_row).each do |i|
        next if spreadsheet.cell("A", i).blank?

        row_data = [spreadsheet.cell("B", i), spreadsheet.cell("C", i), spreadsheet.cell("D", i), "normal"]
        row = [header, row_data].transpose.to_h
        tax_withholding = new row
        tax_withholdings << tax_withholding
      end

      if tax_withholdings_is_valid?(tax_withholdings)
        ActiveRecord::Base.transaction do
          TaxWithholding.normal.destroy_all
          import! tax_withholdings
        end
      else
        false
      end
    end

    def tax_withholdings_is_valid?(data)
      array = data.pluck(:from, :to).flatten
      (1...array.length).none? { |i| array[i] < array[i - 1] }
    end

    def find_tax_by_range(number)
      return 0 unless number

      tax_withholding = TaxWithholding.normal.where("tax_withholdings.from < :number AND tax_withholdings.to >= :number", number: number).first
      return tax_withholding.tax if tax_withholding

      tax_withholding = TaxWithholding.formula.where("tax_withholdings.from < :number AND tax_withholdings.to >= :number", number: number).first
      return tax_withholding.calculate_formula_data(number) if tax_withholding

      0
    end
  end

  def formula_is_validate
    return if formula_data.blank? || errors.key?(:formula_data)

    # only %d, numbers, space and operators
    unless formula_data.match?(%r{^(\d|\s|\.|\+|-|\*|/|%d)*$})
      errors.add(:formula_data)
      return
    end

    # 1 is sample number for test
    _sample = 1
    instance_eval(formula_data.gsub("%d", "_sample"))
  rescue SyntaxError
    errors.add(:formula_data, I18n.t("tax_withholding.errors.formula_invalid"))
  end

  def to_greater_than_from
    return if from.blank? || to.blank?

    errors.add(:to, I18n.t("errors.messages.greater_than", attribute: TaxWithholding.t(:to), count: from)) unless from < to
  end

  def cannot_overlap_another
    return if from.blank? || to.blank?

    overlaps = TaxWithholding.with_kind(kind).exclude_self(id).in_range(from, to)
    errors.add(:base, I18n.t("tax_withholding.errors.invalid")) unless overlaps.empty?
  end

  def calculate_formula_data(data)
    return tax.to_f unless formula?

    _data = data
    instance_eval formula_data.gsub("%d", "_data")
  end
end
