class User < ActiveRecord::Base
  validates :email, length: { minimum: 3 }, uniqueness: { case_sensitive: false }
end
