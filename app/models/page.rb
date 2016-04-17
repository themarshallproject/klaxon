class Page < ActiveRecord::Base
  belongs_to :user
  has_many :page_snapshots
  has_many :email_subscriptions

  attr_accessor :subscriptions
  after_create :update_subscriptions
  after_save :update_subscriptions

  def to_param
    [id, self.name.parameterize].join('-')
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

  def hash
    Digest::SHA256.hexdigest(match_text)
  end

  def scrape
    # TODO
    puts "current hash for #{self.url} is #{self.hash}"
  end

  def current
    {
      html: html,
      hash: hash,
    }
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

end
