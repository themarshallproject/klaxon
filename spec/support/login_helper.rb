module LoginHelper
  def login(user=nil)
    user = User.where(email: 'test@test.com').first_or_create if user.nil?
    request.cookies[:user_id] = user.id
  end

  def current_user
    User.find(request.cookies[:user_id])
  end
end
