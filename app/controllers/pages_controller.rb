class PagesController < ApplicationController
  skip_before_filter :login_required
  layout 'signed_out'
  
  def home
  end

end
