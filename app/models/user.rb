class User < ActiveRecord::Base
  validates :email, length: { minimum: 3 }, uniqueness: { case_sensitive: false }
  has_many :pages

  def full_name
    [first_name, last_name].join(' ')
  end

  def display_name
    full_name.present? ? full_name : email
  end

  def subscriptions
    Subscription.where(watcher: self)
  end

  def watching
    subscriptions.map(&:watching)
  end

  def subscribe(watchable)
    Subscription.where(watcher: self, watching: watchable).first_or_create do |subscription|
      puts "#{self} subscribed to #{watchable}"
    end
  end

  def unsubscribe(watchable)
    Subscription.where(watcher: self, watching: watchable).destroy_all
  end

  def is_subscribed_to?(watchable)
    Subscription.where(watcher: self, watching: watchable).exists?
  end

  def send_notification(change)
    puts "user#send_notification #{self.email}"
    ChangeMailer.page(change: change, user: self).deliver_later
  end

end
