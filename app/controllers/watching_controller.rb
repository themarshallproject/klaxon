class WatchingController < ApplicationController
  before_action :authorize

  def feed
    @changes = Change.includes(after: { page: :user }).order("created_at DESC").first(20)
  end
end
