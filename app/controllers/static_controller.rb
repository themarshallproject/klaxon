class StaticController < ApplicationController
  before_filter :authorize, except: [:unknown_user]

  def help
    path = File.join(Rails.root, 'data', 'help.md')
    markdown = File.read(path)
    @html = Kramdown::Document.new(markdown).to_html
  end

  def unknown_user
  end
  
  def expired_token
    @user = User.find(params[:user_id].to_i)
  end

  def feed
  end

end
