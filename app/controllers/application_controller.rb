class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :authorize
  def authorize
    unless current_user.present?
      redirect_to login_path and return false
    end
  end

  before_filter :set_default_host
  def set_default_host
    unless AppSetting.default_host_exists?
      host = request.host_with_port
      AppSetting.set_default_host(host)
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
