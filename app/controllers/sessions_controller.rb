class SessionsController < ApplicationController
  def new
    # Allow the login page to display in the bookmarklet iframe
    response.headers.delete "X-Frame-Options"
  end

  def create
    user = User.find_by(email: params[:email])
    if user.nil?
      redirect_to unknown_user_path and return false
    end

    UserMailer.login_email(user: user).deliver_later
    # Allow the login page to display in the bookmarklet iframe
    response.headers.delete "X-Frame-Options"
  end

  def token
    user = LoginToken.decode(token: params[:token])

    if user.present?
      cookies.signed[:user_id] = { value: user.id, expires: 7.days.from_now, httponly: true }
      redirect_to root_path
    else
      redirect_to unknown_user_path
    end
  end

  def destroy
    cookies.delete(:user_id)
    redirect_to root_path
  end

end
