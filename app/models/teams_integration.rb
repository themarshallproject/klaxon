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

    page_name = change&.after&.page&.name
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
          "activitySubtitle": "INSERT DATE HERE",
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
              "uri": "https://www.google.com/"
            }
          ]
        },
        {
          "@type": "OpenUri",
          "name": "Compare Snapshots",
          "targets": [
            {
              "os": "default",
              "uri": "https://www.yahoo.com/"
            }
          ]
        },
        {
          "@type": "OpenUri",
          "name": "Snapshot HTML",
          "targets": [
            {
              "os": "default",
              "uri": "https://www.microsoft.com/"
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
