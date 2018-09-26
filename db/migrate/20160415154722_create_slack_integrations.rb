class CreateSlackIntegrations < ActiveRecord::Migration[4.2]
  def change
    create_table :slack_integrations do |t|
      t.string :channel
      t.text :webhook_url

      t.timestamps null: false
    end
  end
end
