class SlackNotification
  def self.perform(url, payload)
    unless Rails.env.production?
      puts "[dev] Skipping Slack notification to #{url}: #{payload.to_json}"
      return true
    end

    json = payload.to_json
    uri = URI.parse(url)
    response = Net::HTTP.post(uri, json, "Content-Type" => "application/json")
    if response.code == "200"
      response.body
    else
      puts "Error sending webhook to url=#{url} for payload=#{payload.to_json}"

      false
    end
  end
end
