class Page < ActiveRecord::Base
  def domain
    domain = Addressable::URI.parse(self.url).host
    domain.gsub(/^www\./,'')
  end
end
