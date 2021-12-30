class TeamsIntegrationsController < ApplicationController
  before_action :set_teams_integration, only: [:show, :edit, :update, :destroy]
  before_action :authorize

  # GET /teams_integrations
  def index
    @teams_integrations = TeamsIntegration.all
  end

  # GET /teams_integrations/1
  def show
  end

  # GET /teams_integrations/new
  def new
    @teams_integration = TeamsIntegration.new
  end

  # GET /teams_integrations/1/edit
  def edit
  end

  # POST /teams_integrations
  def create
    @teams_integration = TeamsIntegration.new(teams_integration_params)

    if @teams_integration.save
      redirect_to integrations_path, notice: 'Teams integration was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /teams_integrations/1
  def update
    if @teams_integration.update(teams_integration_params)
      redirect_to integrations_path, notice: 'Teams integration was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /teams_integrations/1
  def destroy
    @teams_integration.destroy
    redirect_to integrations_path, notice: 'Teams integration was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teams_integration
      @teams_integration = TeamsIntegration.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def teams_integration_params
      params.require(:teams_integration).permit(:channel, :webhook_url)
    end
end
