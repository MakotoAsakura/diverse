# frozen_string_literal: true

module ApplicationHelper
  include Base::ErrorMessagesFor

  def display_zipcode(zipcode)
    return unless zipcode

    "#{zipcode[0..2]}-#{zipcode[3..]}"
  end

  def display_zipcode_with_prefix(zipcode)
    return unless zipcode

    "〒#{zipcode[0..2]}-#{zipcode[3..]}"
  end

  def display_phone_number(phone_number)
    number_to_phone(phone_number).presence || "-"
  end

  def system_setting
    @system_setting ||= SystemSetting.last
  end

  # keep the same if it's a decimal
  # change if it is a natural number
  def convert_number_decimal(number)
    number == number.to_i ? number.to_i : number
  end

  def unread_notification?
    return false unless current_user

    @unread_notification ||=
      begin
        sql = Notification.joins("LEFT OUTER JOIN notification_users ON notification_users.notification_id = notifications.id AND notification_users.user_id = #{current_user.id}")
                          .select("SUM(IF(notification_users.read_at, 0, 1)) AS `unread_count`").opening.to_sql
        ActiveRecord::Base.connection.exec_query(sql).to_a.first["unread_count"]&.positive?
      end
  end

  def employee_unread?
    return false unless current_user

    current_user.candidate.candidate_jobs.exists?(status: %w[waitting rejected], employee_read_at: nil)
  end

  def markdown(text)
    MarkdownRenderer.render(text).html_safe
  end

  def attachments_tags(attachments, html = { class: "list-unstyled" })
    content_tag :ul, class: html[:class] do
      attachments.map do |attachment|
        attachment_lightbox_tag(attachment, parent_tag_name: :li)
      end.join.html_safe
    end
  end

  def has_notice?
    unread_notification? || employee_unread?
  end

  private

  def attachment_lightbox_tag(attachment, html = { class: "text-decoration-underline d-inline-block", parent_tag_name: nil })
    can_preview = %w[image/jpg image/jpeg image/png application/pdf].include?(attachment.file.content_type)
    url = rails_blob_path(attachment.file, disposition: "attachment")
    download_tag = link_to url, class: "text-decoration-unset" do
      "&nbsp; #{image_tag('employee/icons/download-solid.svg', size: 16)}".html_safe
    end

    link = link_to(attachment.filename,
                   can_preview ? rails_blob_path(attachment.file) : image_path("employee/icons/document-2.png"),
                   class: html[:class],
                   target: can_preview ? "_self" : "_blank",
                   data: { framer: "preview", title: "#{attachment.filename} #{download_tag}", download: url }).concat(download_tag)

    return content_tag html[:parent_tag_name], link if html[:parent_tag_name]

    link
  end
end
