class Page < ActiveRecord::Base
  belongs_to :user

  def to_param
    [id, self.name.parameterize].join('-')
  end

  def domain
    host = Addressable::URI.parse(self.url.to_s).host.to_s
    host.gsub(/^www\./, '')
  end

  def current_html
    logger.info "Downloading url=#{self.url}"
    dirty = Net::HTTP.get URI(self.url)
    SafeString.coerce(dirty)
  end

  def document
    Nokogiri::HTML current_html
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

end
