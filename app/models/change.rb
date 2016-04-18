class Change < ActiveRecord::Base
  belongs_to :before, polymorphic: true
  belongs_to :after, polymorphic: true

  validate :correct_ordering
  def correct_ordering
    # delegate order checking to the attached models
    before.created_at < after.created_at
  end

  def notify!
    puts "notify! called for change #{self.to_json}"
    Subscription.where(watching: self.after).map do |subscription|
      subscription.notify!(change)
    end
  end

  def self.check
    Page.all.each do |page|
      page.page_snapshots.all.each_cons(2) do |before, after|
        puts "check change for #{before.id} #{after.id}"
        Change.where(before: before, after: after).first_or_create do |change|
          change.notify!
        end
      end
    end
  end

end
