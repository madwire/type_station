require 'spec_helper'

RSpec.describe TypeStation::Page do

  describe "Validate Single Root page" do
    before do 
      @root = TypeStation::Page.create(title: 'Test Index')
    end
    it "will only allow for one root page to exist" do
      TypeStation::Page.create(title: 'Second Index Page')
      expect(TypeStation::Page.count).to eq(1)
    end 

    it "will allow more that one page that isnt a root page to exist" do
      TypeStation::Page.create(title: 'Child page', parent: @root)
      expect(TypeStation::Page.count).to eq(2)
    end

    it 'will allow me to resave the root page without failing the validatipn' do
      expect(@root.save).to eq(true)
    end
  end

  describe "Slug and Path Generation" do

    describe 'root page' do 
      before do 
        @root = TypeStation::Page.create(title: 'Test Index')
      end

      it "will not generate a slug for a root page" do
        expect(@root.slug).to eq('')
      end

      it "will not generate a path for a root page" do
        expect(@root.path).to eq('/')
      end
    end

    describe 'standard page' do 
      before do
        root = TypeStation::Page.create(title: 'Test Index')
        @page = TypeStation::Page.create(title: 'Test', parent: root)
      end

      it "will not generate a slug for a page" do
        expect(@page.slug).to eq('test')
      end

      it "will not generate a path for a page" do
        expect(@page.path).to eq('/test')
      end
    end

    describe 'Long path page' do 
      before do
        root = TypeStation::Page.create(title: 'Test Index')
        page = TypeStation::Page.create(title: 'Test1', parent: root)
        page2 = TypeStation::Page.create(title: 'Test2', parent: page)
        page3 = TypeStation::Page.create(title: 'Test3', parent: page2)
        @page4 = TypeStation::Page.create(title: 'Test4', parent: page3)
      end

      it "will not generate a slug for a page" do
        expect(@page4.slug).to eq('test4')
      end

      it "will not generate a path for a page" do
        expect(@page4.path).to eq('/test1/test2/test3/test4')
      end
    end
  end

  describe 'Find by path' do
    before do
      root = TypeStation::Page.create(title: 'Test Index')
      page = TypeStation::Page.create(title: 'Test1', parent: root)
      page2 = TypeStation::Page.create(title: 'Test2', parent: page)
      page3 = TypeStation::Page.create(title: 'Test3', parent: page2)
      @page4 = TypeStation::Page.create(title: 'Test4', parent: page3)
    end

    it 'will find a page by its path' do
      expect(TypeStation::Page.find_by_path('/test1/test2/test3/test4')).to eq(@page4)
    end

    it 'will find a page by its path even if the first slash is missing' do
      expect(TypeStation::Page.find_by_path('test1/test2/test3/test4')).to eq(@page4)
    end
    
  end


  describe 'with Contents' do
    before do
      @root = TypeStation::Page.create(title: 'Test Index')
      @root.contents.build(name: :title, type: :text)
      @root.save
    end

    it 'will allow me to access the title contents' do
      @root.set :title, 'Testing'
      expect(@root.get(:title)).to eq('Testing')
    end
  end

end