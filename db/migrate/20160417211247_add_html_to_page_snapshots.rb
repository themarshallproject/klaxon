class AddHtmlToPageSnapshots < ActiveRecord::Migration
  def change
    add_column :page_snapshots, :html, :text
    remove_column :page_snapshots, :s3_url
  end
end
