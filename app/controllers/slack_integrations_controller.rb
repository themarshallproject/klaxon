class SlackIntegrationsController < ApplicationController
  before_action :set_slack_integration, only: [:show, :edit, :update, :destroy]

  # GET /slack_integrations
  def index
    @slack_integrations = SlackIntegration.all
  end

  # GET /slack_integrations/1
  def show
  end

  # GET /slack_integrations/new
  def new
    @slack_integration = SlackIntegration.new
  end

  # GET /slack_integrations/1/edit
  def edit
  end

  # POST /slack_integrations
  def create
    @slack_integration = SlackIntegration.new(slack_integration_params)

    if @slack_integration.save
      redirect_to integrations_path, notice: 'Slack integration was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /slack_integrations/1
  def update
    if @slack_integration.update(slack_integration_params)
      redirect_to integrations_path, notice: 'Slack integration was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /slack_integrations/1
  def destroy
    @slack_integration.destroy
    redirect_to integrations_path, notice: 'Slack integration was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_slack_integration
      @slack_integration = SlackIntegration.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def slack_integration_params
      params.require(:slack_integration).permit(:channel, :webhook_url)
    end
end
