require 'spec_helper'

RSpec.describe "Test", :type => :request do

  describe "With a defined Pages" do

    describe "GET /" do

      before do
        @root = TypeStation::Page.create!(title: 'Index page', template_name: 'blank_index')
        @page = TypeStation::Page.create!(title: 'About us', template_name: 'blank_index', parent: @root)
        @page2 = TypeStation::Page.create!(title: 'Redirect', template_name: 'blank_index', redirect_to: '/place-to-redirect', parent: @root)
        @page3 = TypeStation::Page.create!(title: 'place to redirect', template_name: 'blank_index', parent: @root)
      end

      it "will return 200 on get /" do
        get "/type_station"
        expect(response).to have_http_status(200)
      end

      it "will return 200 on get /type_station/about-us" do
        get "/type_station/about-us"
        expect(response).to have_http_status(200)
      end

      it "will return 200 on get /type_station/about-us/" do
        get "/type_station/about-us/"
        expect(response).to have_http_status(200)
      end

      it "will return 200 on get /type_station/redirect" do
        get "/type_station/redirect"
        expect(response).to have_http_status(302)
      end

    end

  end

  describe "Without a defined Index Page" do
    describe "GET /" do
      it "will return a 404" do
        get "/type_station"
        expect(response).to have_http_status(404)
      end
    end
  end
end