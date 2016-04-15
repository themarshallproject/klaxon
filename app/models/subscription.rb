class Subscription < ActiveRecord::Base
  belongs_to :watcher, polymorphic: true
  belongs_to :watching, polymorphic: true

  def notify!(change)
    Notification.send(subscription: self, change: change)
  end

end
