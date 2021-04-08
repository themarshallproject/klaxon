class RenameColsOnChanges < ActiveRecord::Migration[4.2]
  def change
    rename_column :changes, :prev_id, :before_id
    rename_column :changes, :prev_type, :before_type

    rename_column :changes, :next_id, :after_id
    rename_column :changes, :next_type, :after_type
  end
end
