class User < ActiveRecord::Base
  validates :email, length: { minimum: 3 }, uniqueness: { case_sensitive: false }
  has_many :pages

  def full_name
    [first_name, last_name].join(' ')
  end

  def display_name
    full_name.present? ? full_name : email
  end

end
