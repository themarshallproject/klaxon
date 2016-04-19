class Change < ActiveRecord::Base
  belongs_to :before, polymorphic: true
  belongs_to :after,  polymorphic: true

  validate :correct_ordering
  def correct_ordering
    # delegate order checking to the attached models
    before.created_at < after.created_at
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
    # TODO: extract?
    Page.all.each do |page|
      page.page_snapshots.all.each_cons(2) do |before, after|
        Change.where(before: before, after: after).first_or_create
      end
    end
  end

end
