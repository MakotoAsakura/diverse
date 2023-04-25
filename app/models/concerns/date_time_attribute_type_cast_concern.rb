# frozen_string_literal: true

module DateTimeAttributeTypeCastConcern
  extend ActiveSupport::Concern

  module ClassMethods
    def date_time_attribute(*attributes)
      # gems/date_time_attribute-0.1.2/lib/date_time_attribute.rb:51
      super

      opts = attributes.extract_options!
      time_zone = opts[:time_zone]

      attributes.each do |attribute|
        define_method("#{attribute}_date=") do |val|
          in_time_zone(time_zone) do |time_zone| # rubocop:disable Lint/ShadowingOuterLocalVariable
            container = date_time_container(attribute).in_time_zone(time_zone)
            (container.date = val).tap do
              instance_variable_set("@__#{attribute}_date_before_type_cast", val)
              send("#{attribute}=", container.date_time)
            end
          end
        end

        define_method("#{attribute}_date_before_type_cast") do
          instance_variable_get("@__#{attribute}_date_before_type_cast") || send("#{attribute}_date")&.to_s
        end

        define_method("#{attribute}_time=") do |val|
          in_time_zone(time_zone) do |time_zone| # rubocop:disable Lint/ShadowingOuterLocalVariable
            container = date_time_container(attribute).in_time_zone(time_zone)
            (container.time = val).tap do
              instance_variable_set("@__#{attribute}_time_before_type_cast", val)
              send("#{attribute}=", container.date_time)
            end
          end
        end

        define_method("#{attribute}_time_before_type_cast") do
          instance_variable_get("@__#{attribute}_time_before_type_cast") || send("#{attribute}_time")&.strftime("%H:%M")&.to_s
        end
      end
    end
  end
end
