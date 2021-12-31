class TeamsIntegration < ApplicationRecord

  validates :channel, length: { minimum: 2 }
  validates :webhook_url, length: { minimum: 10 }
  after_destroy :remove_subscriptions

  include Rails.application.routes.url_helpers

  def subscriptions
    Subscription.where(watcher: self)
  end

  def watching
    subscriptions.map(&:watching)
  end

  def subscribe(watchable)
    # TODO: extract this. also in User
    Subscription.where(watcher: self, watching: watchable).first_or_create do |subscription|
      puts "#{self} subscribed to #{watchable}"
    end
  end

  def is_subscribed_to?(watchable)
    Subscription.where(watcher: self, watching: watchable).exists?
  end

  def send_notification(change)
    puts "teams_integration#send_notification #{self.channel}"

    change_date = change&.created_at&.strftime("%A, %B %d, %Y at %H:%M")
    page_name = change&.after&.page&.name
    source_url = change&.after&.page&.url
    edit_url = edit_page_path(change&.after&.page)
    summary = "#{page_name} changed"
    text = "#{page_name} changed #{page_change_url(change)}"

    icon_url = URI.join(root_url, '/images/klaxon-logo-100px.png').to_s

    payload = {
      "@type": "MessageCard",
      "@context": "https://schema.org/extensions",
      "themeColor": "FF0B3A",
      "summary": summary,
      "sections": [
        {
          "activityTitle": "Klaxon",
          "activitySubtitle": change_date,
          "activityImage": icon_url,
          "text": text
        }
      ],
      "potentialAction": [
        {
          "@type": "OpenUri",
          "name": "Go to Source",
          "targets": [
            {
              "os": "default",
              "uri": source_url
            }
          ]
        },
        {
          "@type": "OpenUri",
          "name": "Compare Snapshots",
          "targets": [
            {
              "os": "default",
              "uri": "#{page_change_url(change)}"
            }
          ]
        },
        {
          "@type": "OpenUri",
          "name": "Snapshot HTML",
          "targets": [
            {
              "os": "default",
              "uri": "#{show_page_snapshot_html_url(change)}"
            }
          ]
        },
        {
          "@type": "OpenUri",
          "name": "Edit",
          "targets": [
            {
              "os": "default",
              "uri": edit_url
            }
          ]
        }
      ]
    }

    TeamsNotification.perform(self.webhook_url, payload)
    return payload
  end

  def remove_subscriptions
    subscriptions.each do |s|
      s.destroy
    end
  end
end
