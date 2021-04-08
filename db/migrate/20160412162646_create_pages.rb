class CreatePages < ActiveRecord::Migration[4.2]
  def change
    create_table :pages do |t|
      t.text :name
      t.text :url
      t.text :css_selector
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :pages, :user_id
  end
end
