class AddSummaryToPageSnapshots < ActiveRecord::Migration[4.2]
  def change
    add_column :page_snapshots, :text, :string
  end
end
