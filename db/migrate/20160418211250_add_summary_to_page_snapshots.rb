class AddSummaryToPageSnapshots < ActiveRecord::Migration
  def change
    add_column :page_snapshots, :text, :string
  end
end
