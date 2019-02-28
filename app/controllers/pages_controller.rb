class PagesController < ApplicationController
  before_action :authorize
  before_action :set_page, only: [:show, :edit, :update, :destroy, :latest_change, :snapshots, :setup_compare]

  def latest_change
    change = @page.latest_change
    if change
      redirect_to page_change_path(change)
    else
      redirect_to edit_page_url(@page), notice: 'Not enough snapshots to diff.'
    end
  end

  def snapshots
    @snapshots = @page.page_snapshots.order('created_at DESC').select(:id, :created_at, :sha2_hash)
  end

  def setup_compare
    # TODO extract this
    snapshots = @page.page_snapshots.where(id: [params[:before], params[:after]]).order('created_at ASC').last(2) # TODO: this needs an integration test
    change = Change.where(before: snapshots.first, after: snapshots.last).first_or_create
    redirect_to page_change_path(change)
  end

  # GET /pages
  def index
    @pages = Page.order('created_at DESC').all
  end

  # GET /pages/1
  def show
  end

  # GET /pages/new
  def new
    @page = Page.new
    @users = User.all
    @slack_integrations = SlackIntegration.all
  end

  # GET /pages/1/edit
  def edit
    @users = User.all
    @slack_integrations = SlackIntegration.all
  end

  # POST /pages
  def create
    @page = Page.new(page_params)
    @page.user = current_user

    if @page.save
      redirect_to pages_url, notice: 'Page was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /pages/1
  def update
    if @page.update(page_params)
      redirect_to pages_url, notice: 'Page was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /pages/1
  def destroy
    @page.destroy
    redirect_to pages_url, notice: 'Page was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def page_params
      params.require(:page).permit(:name, :url, :css_selector, :exclude_selector, subscriptions: [])
    end
end
