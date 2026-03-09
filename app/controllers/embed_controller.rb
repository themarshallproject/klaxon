class EmbedController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :inject ]

  def inject
    render plain: 'alert("This Klaxon bookmarklet is outdated. Please visit your Klaxon instance to install the updated version.");', content_type: "text/javascript"
  end
end
