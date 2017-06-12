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
      payload, _config = JWT.decode(token, self.secret_key, true, { algorithm: 'HS256' })
    rescue JWT::ExpiredSignature
      # If the token has expired, try again to decode it, but with expiration
      # checking turned off, so we can tell who tried to log in.
      begin
        payload, _config = JWT.decode(token, self.secret_key, true, { algorithm: 'HS256', verify_expiration: false })

        user_id = payload['data']['user_id']
        user = User.find_by(id: user_id)

        if user.blank?
          return false
        else
          return { user: user, expired: true }
        end
      rescue JWT::DecodeError
        return false
      end
    end

    user_id = payload['data']['user_id']
    return User.find_by(id: user_id)
  end

end
