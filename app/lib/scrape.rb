class Scrape
  def self.all
    Page.all.each do |page|
      begin
        page.scrape
      rescue
        Rails.logger.error "error scraping id=#{page.id} -- '#{$!}'"
      end
    end
  end
end
