require 'rails_helper'

RSpec.describe StaticController, :type => :controller do

  describe "GET support" do
    it "returns http success" do
      get :support
      expect(response).to be_success
    end
  end

end
