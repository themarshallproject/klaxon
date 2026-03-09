class SqsNotification
  def self.perform(queue_url, payload)
    unless Rails.env.production?
      puts "[dev] Skipping SQS notification to #{queue_url}: #{payload.to_json}"
      return true
    end

    client = Aws::SQS::Client.new(
      access_key_id: ENV["AWS_ACCESS_KEY_ID"] || ENV["ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"] || ENV["SECRET_ACCESS_KEY"],
      region: "us-east-1"
    )
    json = payload.to_json

    begin
      client.send_message({
        delay_seconds: 10,
        message_attributes: {
          "payload" => {
            data_type: "String",
            string_value: json
          }
        },
        message_body: json,
        queue_url: queue_url
      })
    rescue Aws::SQS::Errors::ServiceError => e
      puts "Error sending SQS message to queue_url=#{queue_url} for payload=#{payload.to_json}; Error: #{e}"

      false
    end
  end
end
