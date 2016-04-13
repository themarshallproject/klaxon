class Page < ActiveRecord::Base
  belongs_to :user

  def to_param
    [id, self.name.parameterize].join('-')
  end

  def domain
    Addressable::URI.parse(self.url.to_s)
      .host
      .gsub(/^www\./, '')
  end

end
