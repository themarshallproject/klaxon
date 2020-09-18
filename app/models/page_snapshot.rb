class PageSnapshot < ApplicationRecord
  belongs_to :page

  validates :sha2_hash, presence: true

  after_destroy do |record|
    Change.destroy_related(record)
  end

  def document
    Nokogiri::HTML(html)
  end

  def match_text
    @match = document.css(self.page.css_selector)

    if self.page.exclude_selector.present?
      # Set the content of the exclude selector to the empty string
      @match.css(self.page.exclude_selector).each do |node|
        node.content = ""
      end
    end

    @match.text
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

  def filename
    filename = self.page.name.gsub(" ","-") + "-" + self.created_at.to_s.gsub(" ","-") + ".html"
  end
end
