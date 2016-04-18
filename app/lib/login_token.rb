class LoginToken

  def self.secret_key
    ENV['SECRET_KEY_BASE']
  end

  def self.create(user: nil)
    payload = {
      data: { user_id: user.id },
      exp: 1.hour.from_now.to_i
    }
    JWT.encode(payload, self.secret_key, 'HS256')
  end

  def self.decode(token: nil)
    if token.nil?
      return "invalid"
    end

    begin
      payload, _config = JWT.decode(token, self.secret_key, 'HS256')
    rescue JWT::ExpiredSignature
      return false
    end

    user_id = payload['data']['user_id']
    return User.find_by(id: user_id)
  end

end
