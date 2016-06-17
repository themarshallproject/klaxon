class Page < ActiveRecord::Base
  belongs_to :user

  has_many :page_snapshots, dependent: :destroy

  attr_accessor :subscriptions
  after_create :update_subscriptions
  after_save   :update_subscriptions

  def to_param
    [id, self.name.to_s.parameterize].join('-')
  end

  def domain
    host = Addressable::URI.parse(self.url.to_s).host.to_s
    host.gsub(/^www\./, '')
  end

  def html
    if self.url.blank?
      return ''
    end

    @html ||= begin
      logger.info "downloading url=#{self.url} for page.id=#{self.id}"
      dirty = Net::HTTP.get(URI(self.url.to_s))
      SafeString.coerce(dirty)
    end
  end

  def document
    Nokogiri::HTML(html)
  end

  def match_text
    document.css(self.css_selector).text
  end

  def match_html
    document.css(self.css_selector).to_html
  end

  def sha2_hash
    Digest::SHA256.hexdigest(match_text)
  end

  def update_subscriptions
    # REFACTOR
    ActiveRecord::Base.transaction do
      Subscription.where(watching: self).destroy_all

      subscriptions.to_a.each do |subscription|
        model, id = subscription.split(':') # TODO
        if model == 'user'
          User.find(id).subscribe(self)
        elsif model == 'slack'
          SlackIntegration.find(id).subscribe(self)
        else
          raise "unknown subscription type"
        end
      end
    end
  end

  def latest_change
    after, before = PageSnapshot.where(page: self).order('created_at DESC').first(2)

    if before.nil? or after.nil?
      return false
    end

    Change.where(before: before, after: after).first_or_create # TODO extract
  end

  def snapshot_time_deltas
    snapshots = self.page_snapshots.order('created_at ASC').select(:created_at)

    snapshots.map{ |snapshot|
      snapshot.created_at.utc.to_i
    }.each_cons(2).map{ |before, after|
      after - before
    }
  end

end
