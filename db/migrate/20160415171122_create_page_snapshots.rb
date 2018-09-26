class CreatePageSnapshots < ActiveRecord::Migration[4.2]
  def change
    create_table :page_snapshots do |t|
      t.integer :page_id
      t.text :s3_url

      t.timestamps null: false
    end
    add_index :page_snapshots, :page_id
  end
end
