class SqsNotification
  def self.perform(queue_url, payload)
    client = Aws::SQS::Client.new(
      access_key_id: ENV["AWS_ACCESS_KEY_ID"] || ENV["ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"] || ENV["SECRET_ACCESS_KEY"],
      region: 'us-east-1'
    )
    json = payload.to_json

    begin
      return client.send_message({
        delay_seconds: 10,
        message_attributes: {
          "payload" => {
            data_type: "String",
            string_value: json,
          }
        },
        message_body: json,
        queue_url: queue_url,
      })
    rescue Aws::SQS::Errors::ServiceError => e
      puts "Error sending SQS message to queue_url=#{queue_url} for payload=#{payload.to_json}; Error: #{e}"
      return false
    end
  end
end
