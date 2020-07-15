class Change < ApplicationRecord
  belongs_to :before, polymorphic: true
  validates  :before, presence: true

  belongs_to :after, polymorphic: true
  validates  :after, presence: true

  validate :correct_ordering
  def correct_ordering
    # delegate order checking to the attached models
    if before.nil? or after.nil?
      # let this be caught by the presence validation, rather than fail at the `created_at` call below
      return
    end

    if before.created_at > after.created_at
      errors.add(:after, "'after' must be created_at after 'before'")
    end
  end

  # TODO: service object should manage creating changes and notifications, after_create for now
  after_create :send_notifications
  def send_notifications
    subscriptions = Subscription.where(watching: self.after.parent)
    subscriptions.all.map do |subscription|
      begin
        subscription.send_notification(self)
      rescue Exception => e
        puts "Error sending notification for Change #{self.id}", e
      end
    end

    # unlike people and slack channels, there are no "subscriptions" to SQS integrations,
    # instead, all changes are sent to the queue -- allowing the consumer to choose which to act on
    SqsIntegration.all.each{|sqs_integration| sqs_integration.send_notification(self) }
  end

  def self.check
    Page.all.each do |page|
      # if we have multiple snapshots, only notify for the change between the last two

      current = page.page_snapshots.order('created_at DESC').first

      Change.where(
        before: current&.previous, # this can pass nil, but it will be throw an error if so
        after:  current
      ).first_or_create
    end
  end

  def self.destroy_related(record)
    self.where(before: record).destroy_all
    self.where(after: record).destroy_all
  end
end
