class SqsIntegration < ApplicationRecord

  validates :queue_url, length: { minimum: 10 }
  validate :starts_with_https
  def starts_with_https
    if queue_url.to_s.split('').first(5).join('') != 'https'
      errors.add(:queue_url, "must begin with https")
    end
  end

  include Rails.application.routes.url_helpers

  def send_notification(change)
    puts "sqs_integration#send_notification #{self.queue_url}"

    page_name = change&.after&.page&.name
    text = "#{page_name} changed #{change&.after&.page&.url}"

    payload = {
      "page_name": page_name,
      "text": text,
      "change_page_url": page_change_url(change),

      "url": change&.after&.page&.url,
      "event": "update",
      "source": "klaxon",
      "type": "external",
      "eventTS": Time.now.to_i
    }

    SqsNotification.perform(self.queue_url, payload)
    return payload
  end

end
