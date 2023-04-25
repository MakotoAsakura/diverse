# frozen_string_literal: true

module Base
  module Scope
    module Base
      extend ActiveSupport::Concern

      included do
        scope :by_year, ->(year) { where(year: year) }
        scope :by_month, ->(month) { where(month: month) }
      end

      module ClassMethods
        def keyword_in(word, field)
          query = "%#{word}%"
          field_match = arel_table[field.to_sym].matches(query)
          where(field_match)
        end

        def value_in(keys, field)
          field_match = arel_table[field.to_sym].in(keys)
          where(field_match)
        end

        def time_compare(field, compare_type, time)
          field_match = arel_table[field.to_sym].send(compare_type.to_sym, time)
          where(field_match)
        end
      end
    end
  end
end
