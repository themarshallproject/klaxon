class PagesController < ApplicationController
  before_action :authorize
  before_action :set_page, only: [:show, :edit, :update, :destroy, :latest_change]

  def latest_change
    render text: 'redirect generated here'
  end

  # GET /pages
  def index
    @pages = Page.all
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
      params.require(:page).permit(:name, :url, :css_selector, subscriptions: [])
    end
end
