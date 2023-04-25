# frozen_string_literal: true

ActionView::Base.field_error_proc = proc do |html_tag, instance|
  element = Nokogiri::HTML.fragment(html_tag).child
  options = instance.instance_variable_get(:@options)

  danger_class =
    if options[:render_field_error] != false
      if options[:render_field_error_class].is_a?(String)
        options[:render_field_error_class]
      elsif options[:render_field_error_class] != false
        "danger"
      end
    end

  # rubocop:disable Rails/OutputSafety

  if element.node_name == "label" || options[:render_field_error] == false
    element.to_s.html_safe
  elsif element["type"].in? %w[radio checkbox file]
    element["class"] ||= ""
    element["class"] += " #{danger_class}" if danger_class

    element.to_s.html_safe
  else
    element["class"] ||= ""
    element["class"] += " #{danger_class}" if danger_class

    error_message_template =
      %(<div class="i-helper #{danger_class}">%<message>s</div>)
    error_messages =
      if options[:render_field_error_message] != false
        [instance.error_message].flatten.map do |message|
          format(error_message_template, message: message)
        end.join
      end
    [element.to_s, error_messages].join.html_safe
  end

  # rubocop:enable Rails/OutputSafety
end
