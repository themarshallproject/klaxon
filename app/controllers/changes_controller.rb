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

  def html
    @change_id=params[:change_id]
    @snapshot = PageSnapshot.find(@change_id)
    @page = Page.find(@snapshot.page_id)
    @timestamp = @snapshot.created_at
    @html = @snapshot.html
  end

  def download
    @id = params[:change_id]
    @change_id = @id
    @snapshot = PageSnapshot.find(@id)
    @html = @snapshot.html
    @parent_page = Page.find(@snapshot.page_id)
    @filename = @parent_page.name.gsub(" ","-") + "-" + @snapshot.created_at.to_s.gsub(" ","-") + ".html"
    send_data(@html,
          :filename => @filename,
          :type => 'text/html',
          :disposition => 'attachment') 
  end

  private

  def set_change
    @change = Change.find(params[:change_id])
  end

  def change_params
    params.require(:change).permit(:summary)
  end

end
