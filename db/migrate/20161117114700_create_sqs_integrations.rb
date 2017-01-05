class CreateSqsIntegrations < ActiveRecord::Migration
  def change
    create_table :sqs_integrations do |t|
      t.text :queue_url

      t.timestamps null: false
    end
  end
end
