class PageSnapshot < ActiveRecord::Base
  belongs_to :page
  validates :page, presence: true
  validates :sha2_hash, presence: true

  after_destroy do |record|
    Change.destroy_related(record)
  end

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
    siblings.where('created_at < ?', self.created_at).order('created_at DESC').first
  end

  def siblings
    parent.page_snapshots.where.not(id: self.id)
  end

  def parent
    self.page
  end

  def blank_match_text?
    self.match_text.blank?
  end

end
