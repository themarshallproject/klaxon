class ChangeMailer < ApplicationMailer

  def page(change)
    @change = change
  end

end
