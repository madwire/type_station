require 'spec_helper'

RSpec.describe "Test", :type => :request do
  describe "GET /" do
    it "works! (now write some real specs)" do
      get "/type_station"
      expect(response).to have_http_status(200)
    end
  end
end