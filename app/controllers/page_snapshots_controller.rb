class PageSnapshotsController < ApplicationController
  before_action :set_snapshot, only: [:html, :raw_html, :download]
  before_action :authorize

  def html
  end

  def raw_html
    return render html: @snapshot.html.html_safe
  end

  def download
    send_data(@snapshot.html,
          :filename => @snapshot.filename,
          :type => 'text/html',
          :disposition => 'attachment')
  end

  private
  def set_snapshot
    @snapshot = PageSnapshot.find(params[:page_snapshot_id])
  end
end
