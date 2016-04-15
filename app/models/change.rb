class Change < ActiveRecord::Base
  belongs_to :before, polymorphic: true
  belongs_to :after, polymorphic: true

  validate :correct_ordering
  def correct_ordering
    # delegate order checking to the attached models
    before.created_at < after.created_at
  end

  def notify!
    Subscriptions.where(watching: self.after).map do |subscription|
      subscription.notify!(change)
    end
  end

end
