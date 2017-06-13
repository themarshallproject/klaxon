class ApiController < ApplicationController
  skip_before_filter  :verify_authenticity_token
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

  # Send content for a page
  def pages_content
    page = Page.find_by(id: params[:id])
    unless page
      return render json: { errors: [ { detail: "Unable to find page" } ] }, status: 404
    end

    # Get content
    content = params[:content]
    unless content
      return render json: { errors: [ { detail: "content paramter not provided" } ] }, status: 400
    end

    # Check page content
    page.custom_html(content)
    changes = PollPage.perform(page: page)

    puts changes.inspect

    if changes
      render json: changes
      Change.check
    else
      render json: { changed: false, status: 'No changes noticed' }
    end
  end

  def authorize
    if defined? @current_user
      return @current_user
    end

    @current_user = false

    authenticate_with_http_token do |token, options|
      @current_user = User.find_by(auth_token: token)
    end

    unless @current_user
      render json: { errors: [ { detail: "Access denied" } ] }, status: 401
    end
    return @current_user
  end
end
