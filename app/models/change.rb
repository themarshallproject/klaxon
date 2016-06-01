class Change < ActiveRecord::Base
  belongs_to :before, polymorphic: true
  belongs_to :after,  polymorphic: true

  validate :correct_ordering
  def correct_ordering
    # delegate order checking to the attached models
    if before.created_at > after.created_at
      errors.add(:after, "'after' must be created_at after 'before'")
    end
  end

  # TODO: service object should manage creating changes and notifications, after_create for now
  after_create :send_notifications
  def send_notifications
    subscriptions = Subscription.where(watching: self.after.parent)
    subscriptions.all.map do |subscription|
      subscription.send_notification(self)
    end
  end

  def self.check
    Page.all.each do |page|
      # if we have multiple snapshots, only notify for the change between the last two
      most_recent = page.page_snapshots.order('created_at DESC').first
      Change.where(
        before: most_recent.previous,
        after:  most_recent
      ).first_or_create
    end
  end

end
