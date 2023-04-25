# frozen_string_literal: true

module Medical
  module JobsHelper
    def display_around_post_period(item)
      return "-" if item.open_at.blank? || item.close_at.blank?

      "#{l(item.open_at, format: :long_day)}　〜　#{l(item.close_at, format: :long_day)}"
    end

    def display_around_annual_salary(item)
      return "-" if item.min_annual_salary.blank? || item.max_annual_salary.blank?

      "#{number_with_delimiter item.min_annual_salary}円　〜　#{number_with_delimiter item.max_annual_salary}円"
    end

    def display_around_annual_salary_before(item)
      return "-" if item.min_annual_salary.blank? || item.max_annual_salary.blank?

      "¥#{number_with_delimiter item.min_annual_salary}〜¥#{number_with_delimiter item.max_annual_salary}"
    end

    def display_around_annual_salary_according(item)
      return "-" if item.min_annual_salary.blank? || item.max_annual_salary.blank?

      "#{number_with_delimiter item.min_annual_salary}円　〜　#{number_with_delimiter item.max_annual_salary}円（#{item.salary_according_to_i18n}）"
    end

    def display_around_start(item)
      return "-" if item.start_at.blank? || item.end_at.blank?

      "#{l(item.start_at, format: :long_day)}　〜　#{l(item.end_at, format: :long_day)}"
    end

    def display_around_hours_wday(item)
      return "-" if item.wday_start_at.blank? || item.wday_end_at.blank?

      "#{l(item.wday_start_at, format: :hour_minute)}　〜　#{l(item.wday_end_at, format: :hour_minute)}"
    end

    def display_quantity(item)
      return "-" if item.quantity.blank?

      "#{item.quantity}名"
    end
  end
end
