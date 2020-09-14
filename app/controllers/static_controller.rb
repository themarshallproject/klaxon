class StaticController < ApplicationController
  before_action :authorize

  def help
    path = File.join(Rails.root, 'data', 'help.md')
    markdown = File.read(path)
    @html = Kramdown::Document.new(markdown).to_html
  end

  def feed
  end
end
