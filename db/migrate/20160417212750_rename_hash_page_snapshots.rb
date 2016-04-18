class RenameHashPageSnapshots < ActiveRecord::Migration
  def change
    rename_column :page_snapshots, :hash, :sha2_hash
  end
end
