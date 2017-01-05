class SqsIntegrationsController < ApplicationController
  before_action :set_sqs_integration, only: [:show, :edit, :update, :destroy]

  # GET /sqs_integrations
  def index
    @sqs_integrations = SqsIntegration.all
  end

  # GET /sqs_integrations/1
  def show
  end

  # GET /sqs_integrations/new
  def new
    @sqs_integration = SqsIntegration.new
  end

  # GET /sqs_integrations/1/edit
  def edit
  end

  # POST /sqs_integrations
  def create
    @sqs_integration = SqsIntegration.new(sqs_integration_params)

    if @sqs_integration.save
      redirect_to integrations_path, notice: 'SQS integration was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /sqs_integrations/1
  def update
    if @sqs_integration.update(sqs_integration_params)
      redirect_to integrations_path, notice: 'SQS integration was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /sqs_integrations/1
  def destroy
    @sqs_integration.destroy
    redirect_to integrations_path, notice: 'SQS integration was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sqs_integration
      @sqs_integration = SqsIntegration.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def sqs_integration_params
      params.require(:sqs_integration).permit(:queue_url)
    end
end
