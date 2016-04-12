class User < ActiveRecord::Base
  validates :email, length: { minimum: 3 }, uniqueness: { case_sensitive: false }
  has_many :pages
end
