class IntegrationsController < ApplicationController
  before_action :authorize

  def index
    @slack_integrations = SlackIntegration.all
    @sqs_integrations = SqsIntegration.all
    @teams_integrations = TeamsIntegration.all
  end
end
