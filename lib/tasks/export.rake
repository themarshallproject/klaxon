namespace :export do
  desc "Export the snapshots from a given page"
  task snapshots: :environment do
    page = Page.find(219)
    snapshots = page.page_snapshots
    snapshots.each do |snapshot|
      File.write("snapshots/snapshot-#{snapshot.created_at.iso8601}", snapshot.html)
    end
  end
end
