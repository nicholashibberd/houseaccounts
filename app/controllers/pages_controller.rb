class PagesController < ApplicationController
  skip_before_filter :login_required
  
  def home
  end

end
