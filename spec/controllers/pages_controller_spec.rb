require 'spec_helper'

describe PagesController do

  describe "GET 'home'" do
    it "should be render the homepage if the user is not signed in" do
      get 'home'
      response.should be_success
    end

    it "should redirect to the user page if the user is signed in" do
      user = mock_model(User)
      controller.stub!(:current_user).and_return(user)
      get 'home'
      response.should redirect_to user_path(user)
    end
  end

end
