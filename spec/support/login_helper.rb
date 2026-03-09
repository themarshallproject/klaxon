module LoginHelper
  def login(user = nil)
    user = User.where(email: 'test@test.com').first_or_create if user.nil?
    cookies[:user_id] = user.id
    user
  end

  def current_user
    User.find(cookies[:user_id])
  end
end
