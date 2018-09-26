class AddHtmlToPageSnapshots < ActiveRecord::Migration[4.2]
  def change
    add_column :page_snapshots, :html, :text
    remove_column :page_snapshots, :s3_url
  end
end
