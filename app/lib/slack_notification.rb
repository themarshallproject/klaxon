class SlackNotification
  def self.perform(url, payload)
    json = payload.to_json
    request = HTTParty.post(url, body: json)
    if request.code == 200
      request.body
    else
      puts "Error sending webhook to url=#{url} for payload=#{payload.to_json}"
      return false
    end
  end
end
