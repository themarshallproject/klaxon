class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user.nil?
      redirect_to unknown_user_path and return false
    end

    payload = {
      data: { user_id: user.id },
      exp: 10.minutes.from_now.to_i
    }
    token = JWT.encode(payload, ENV['SECRET_KEY_BASE'], 'HS256')

    UserMailer.login_email(user: user, token: token).deliver_later

    render 'create'
  end

  def token
    token = params[:token]
    payload, _config = JWT.decode(token, ENV['SECRET_KEY_BASE'], 'HS256')

    user_id = payload['data']['user_id']
    user = User.find_by(id: user_id)

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
