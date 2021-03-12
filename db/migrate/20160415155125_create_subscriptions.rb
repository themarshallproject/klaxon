class CreateSubscriptions < ActiveRecord::Migration[4.2]
  def change
    create_table :subscriptions do |t|
      t.integer :watcher_id
      t.string :watcher_type
      t.integer :watching_id
      t.string :watching_type

      t.timestamps null: false
    end
    add_index :subscriptions, :watcher_id
    add_index :subscriptions, :watcher_type
    add_index :subscriptions, :watching_id
    add_index :subscriptions, :watching_type
  end
end
