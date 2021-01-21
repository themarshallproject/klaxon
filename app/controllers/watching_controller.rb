class WatchingController < ApplicationController
  before_action :authorize

  def feed
    @changes = Change.order('created_at DESC').first(20)
  end
end
