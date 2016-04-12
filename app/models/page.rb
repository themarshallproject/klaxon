class Page < ActiveRecord::Base
  belongs_to :user

  def to_param
    [id, name.parameterize].join('-')
  end
end
