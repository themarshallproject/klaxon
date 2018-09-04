class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :authorize
  def authorize
    unless current_user.present?
      redirect_to login_path(return_to: request.original_url) and return false
    end
  end

  before_action :set_default_host
  def set_default_host
    # determine the host we're running on, so we can generate urls for emails, etc
    # keep this in an AppSetting (persisted) and pass to Rails when blank

    host_setting_exists = AppSetting.default_host_exists?
    unless host_setting_exists
      host = request.host_with_port
      AppSetting.set_default_host(host)
    end

    if Rails.application.routes.default_url_options[:host].blank? and host_setting_exists
      host = AppSetting.default_host
      Rails.logger.info "setting default_host to #{host}"
      Rails.application.routes.default_url_options[:host] = host
    end
  end

  helper_method :current_user
  def current_user
    if defined? @current_user
      return @current_user
    end

    if cookies.signed[:user_id].blank?
      @current_user = false
      return @current_user
    end

    user = User.find_by(id: cookies.signed[:user_id])
    if user.present?
      cookies.signed[:user_id] = { value: user.id, expires: 7.days.from_now, httponly: true }
      @current_user = user
    else
      cookies.signed[:user_id] = nil
      @current_user = false
    end

    return @current_user
  end

end
