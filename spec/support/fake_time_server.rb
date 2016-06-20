require 'sinatra/base'

class FakeTimeServer < Sinatra::Base

  get '/now' do
    time = Time.now.utc.to_f
    puts "FakeTimeServer GET /now time=#{time}"
    "<html><body>#{time}</body></html>"
  end

end
