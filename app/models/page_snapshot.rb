class PageSnapshot < ActiveRecord::Base
  belongs_to :page
  validates :page, presence: true

end
