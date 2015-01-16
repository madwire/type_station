require 'spec_helper'

RSpec.describe TypeStation::Content do
  subject {TypeStation::Content.new(name: :title, type: :text)}
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:type) }

  describe 'Text' do
    before do
      @content = TypeStation::Content.new(name: :title, type: :text)
    end

    it 'will return my simple text' do
      @content.set('My Test')
      expect(@content.get).to eq('My Test')
    end
  end


  describe 'Multiple Select' do
    before do
      @content = TypeStation::Content.new(name: :title, type: :multiple_select)
      @content2 = TypeStation::Content.new(name: :title, type: :multiple_select)
    end

    it 'will return an array from string' do
      @content.set('My Test')
      @content2.set('My Test, Test 2')
      expect(@content.get).to eq(['My Test'])
      expect(@content2.get).to eq(['My Test', 'Test 2'])
    end

    it 'will return an array from array' do
      @content.set(['My Test'])
      expect(@content.get).to eq(['My Test'])
    end
  end
end