class RenameHashPageSnapshots < ActiveRecord::Migration[4.2]
  def change
    rename_column :page_snapshots, :hash, :sha2_hash
  end
end
