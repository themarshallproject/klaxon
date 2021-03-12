class Subscription < ApplicationRecord
  belongs_to :watcher, polymorphic: true
  validates :watcher, presence: true

  belongs_to :watching, polymorphic: true
  validates :watching, presence: true

  def send_notification(change)
    watcher.send_notification(change)
  end

end
