class PollPage
  def self.perform(page: nil)
    html = page.html
    sha2_hash = page.sha2_hash

    # TODO: this will not catch changes if a page goes
    # from state A to state B, then back to state A, as state A already is recorded
    # perhaps this should check if the current sha2 is not equal to the most recent page_snapshot?
    existing = PageSnapshot.find_by(page: page, sha2_hash: sha2_hash)

    if existing
      existing.touch
      puts "page id='#{page.id}' has not changed"
      return false
    end

    return PageSnapshot.create(page: page, sha2_hash: sha2_hash, html: html)
  end

  def self.perform_all
    Page.all.shuffle.each do |page|
      begin
        self.perform(page: page)
      rescue StandardError => e
        puts "Pollpage.perform had an error on #{page.url}: #{e}"
        puts e.backtrace
      end
    end
  end
end
