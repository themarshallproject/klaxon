class LoginToken

  def self.secret_key
    ENV['SECRET_KEY_BASE']
  end

  def self.create(user: nil)
    payload = {
      data: { user_id: user.id },
      exp: 10.minutes.from_now.to_i
    }
    JWT.encode(payload, self.secret_key, 'HS256')
  end

  def self.decode(token: nil)
    if token.nil?
      return "invalid"
    end

    payload, _config = JWT.decode(token, self.secret_key, 'HS256')
    user_id = payload['data']['user_id']
    User.find_by(id: user_id)
  end

end
