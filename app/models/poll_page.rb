class PollPage
  def self.perform(page: nil)
    html = page.html
    sha2_hash = page.sha2_hash

    existing = PageSnapshot.find_by(page: page, sha2_hash: sha2_hash)
    if existing
      existing.touch
      puts "page #{page.id} has not changed"
      return false
    end

    return PageSnapshot.create(page: page, sha2_hash: sha2_hash, html: html)
  end

  def self.perform_all
    Page.all.shuffle.each do |page|
      self.perform(page: page)
    end
  end
end
