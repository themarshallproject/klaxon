class Subscription < ActiveRecord::Base
  belongs_to :watcher, polymorphic: true
  validates :watcher, presence: true

  belongs_to :watching, polymorphic: true
  validates :watching, presence: true

  def notify!(change)
    Notification.send(subscription: self, change: change)
  end

end
