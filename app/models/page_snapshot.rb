class PageSnapshot < ActiveRecord::Base
  belongs_to :page
  validates :page, presence: true

  validates :sha2_hash, presence: true, uniqueness: true

  def document
    Nokogiri::HTML(html)
  end

  def match_text
    document.css(self.page.css_selector).text
  end

  def display_hash
    sha2_hash.first(8)
  end

  def previous

  end

end
