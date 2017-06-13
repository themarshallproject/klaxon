require 'SecureRandom'

class User < ActiveRecord::Base
  before_create :set_auth_token
  validates :email, length: { minimum: 3 }, uniqueness: { case_sensitive: false }
  validate :email_domain_is_approved, on: [ :create, :update ]
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

  def email_domain_is_approved
    if not (email || '').include?('@')
      errors.add(:email, 'Email address is invalid.')
      return false
    end

    user_domain = email.strip.split('@')[-1].downcase
    approved_domains = (ENV['APPROVED_USER_DOMAINS'] || '').strip.downcase.split(',')

    approve_any_domain = approved_domains.length == 0
    domain_is_approved = approved_domains.include?(user_domain)

    if not (approve_any_domain or domain_is_approved)
      errors.add(:email, 'Email address belongs to a non-approved domain.')
      return false
    end
  end

  private
  def set_auth_token
    return if auth_token.present?
    self.auth_token = generate_auth_token
  end

  def generate_auth_token
    SecureRandom.uuid.gsub(/\-/,'')
  end

  def invalidate_auth_token
    self.update_columns(auth_token: nil)
  end

end
