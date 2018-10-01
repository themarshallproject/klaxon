class AddHashToPageSnapshots < ActiveRecord::Migration[4.2]
  def change
    add_column :page_snapshots, :hash, :string
    add_index :page_snapshots, :hash
  end
end
