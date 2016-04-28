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

  def embed_find_page # POST request
    page = Page.where(url: params[:url]).first_or_create do |page|
      page.user = current_user
    end

    render json: page
  end

  def embed_update_page_selector  # POST request
    page = Page.find_by(id: params[:id])
    page.css_selector = params[:css_selector]
    if page.save
      render json: page
    else
      render json: {}, status: 422
    end
  end

  def page_preview
    page = Page.new(url: params[:url], css_selector: params[:css_selector])
    render json: {
      url: page.url,
      css_selector: page.css_selector,
      match_text: page.match_text
    }
  end

end
