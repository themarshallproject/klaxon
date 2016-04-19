class ChangesController < ApplicationController

  before_action :authorize

  def page
    @change = Change.find(params[:change_id])
    @before = @change.before
    @after = @change.after

    @page = @after.page
    @snapshots = @page.page_snapshots
  end

  def resend
    change = Change.find(params[:id])
    render json: change.send_notifications
  end

end
