class StaticController < ApplicationController
  before_filter :authorize, except: [:unknown_user]

  def index
    @users = User.all
  end

  def help
    path = File.join(Rails.root, 'data', 'help.md')
    markdown = File.read(path)
    @html = Kramdown::Document.new(markdown).to_html
  end

  def unknown_user
  end

  def feed
  end

end
