class IntegrationsController < ApplicationController
  def index
    @slack_integrations = SlackIntegration.all
  end
end
