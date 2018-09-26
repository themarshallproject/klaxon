class CreateChanges < ActiveRecord::Migration[4.2]
  def change
    create_table :changes do |t|
      t.integer :prev_id
      t.string :prev_type
      t.integer :next_id
      t.string :next_type
      t.text :summary

      t.timestamps null: false
    end
    add_index :changes, :prev_id
    add_index :changes, :prev_type
    add_index :changes, :next_id
    add_index :changes, :next_type
  end
end
