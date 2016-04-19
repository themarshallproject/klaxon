class SlackIntegration < ActiveRecord::Base

  validates :channel, length: { minimum: 2 }
  validates :webhook_url, length: { minimum: 10 }
  validate :starts_with_hash
  def starts_with_hash
    if channel.to_s.split('').first != '#'
      errors.add(:channel, "must begin with #")
    end
  end

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
    puts "slack_integration#send_notification #{self.channel}"

    page_name = change&.after&.page&.name
    text = "#{page_name} changed #{page_change_url(change)}"

    payload = {
      "name": "Klaxon",
      "icon_url": ActionController::Base.helpers.asset_url("klaxon-logo-100px.png"),
      "channel": self.channel,
      "text": text,
    }

    SlackNotification.perform(self.webhook_url, payload)

    return payload
  end

end
