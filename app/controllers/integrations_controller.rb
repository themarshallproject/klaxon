class IntegrationsController < ApplicationController
  def index
    @slack_integrations = SlackIntegration.all
    @sqs_integrations = SqsIntegration.all    
  end
end
