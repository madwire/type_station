require 'spec_helper'

RSpec.describe TypeStation::PagePresenter do
  describe 'with a page with content objects' do
    before do 
      TypeStation::Content.new
      @root = TypeStation::Page.create(title: 'Test Index')
      @page = TypeStation::Page.create(title: 'Test Page', parent: @root)
      @page.contents.build(name: :title_test, type: :text)
      @page.contents.build(name: :body, type: :html)
      @presenter = TypeStation::PagePresenter.new @page, Struct.new(:test)
    end

    it 'will create a method for each content object' do
      @page.set(:title_test, 'My word')
      @page.set(:body, 'My word')
      expect(@presenter.title_test.value).to eq('My word')
      expect(@presenter.body.value).to eq('My word')
    end

    it "will allow me to get access to the path and slug" do
      expect(@presenter.path).to eq('/test-page')
      expect(@presenter.slug).to eq('test-page')
    end

    it "will allow me to get to the page children" do
       expect(@presenter.children.class).to eq(Array)
    end

    it "will allow me to get to the parent page" do
      expect(@presenter.parent.class).to eq(TypeStation::PagePresenter)
    end

  end

end