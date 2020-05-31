class ChangesController < ApplicationController
  before_action :set_change, only: [:page, :update, :resend]
  before_action :authorize

  def page
    @before = @change.before
    @after = @change.after

    @page = @after.page
    @snapshots = @page.page_snapshots
  end

  # PATCH/PUT /changes/1
  def update
    if @change.update(change_params)
      redirect_to page_change_url(@change), notice: 'change was successfully updated.'
    else
      render :page
    end
  end

  def resend
    render json: @change.send_notifications
  end

  private

  def set_change
    @change = Change.find(params[:change_id])
  end

  def change_params
    params.require(:change).permit(:summary)
  end
end
