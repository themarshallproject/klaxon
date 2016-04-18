class ApiController < ApplicationController
  before_action :authorize

  def subscriptions
    render json: Subscription.all
  end

  def users
    render json: User.all
  end

  def pages
    render json: Page.all
  end

  def stats
    render json: {
      pages_count: Page.count,
      page_snapshots_count: PageSnapshot.count,
      users_count: User.count,
      changes_count: Change.count,
    }
  end
end
