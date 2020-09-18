class CreateAppSettings < ActiveRecord::Migration[4.2]
  def change
    create_table :app_settings do |t|
      t.string :key
      t.text :value

      t.timestamps null: false
    end
    add_index :app_settings, :key
  end
end
