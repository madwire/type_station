require 'spec_helper'

RSpec.describe TypeStation::Admin::PagesController do
  routes { TypeStation::Engine.routes }
  
  before do
    @page = TypeStation::Page.create(title: 'Index page', template_name: 'blank_index')
    @content_text = @page.contents.build(name: :existing_text_field, type: :text)
    @content_text.set('Old value')
  end

  it 'will create any missing fields' do
    patch :update, id: @page.to_param, contents: { field: 'text_field',value: 'My Text', type: 'text'}
    @page.reload
    expect(@page.get(:text_field)).to eq('My Text')
    expect(response.status).to eq(200)
  end

  it 'will create multiple missing fields' do
    patch :update, id: @page.to_param, contents: [{ field: 'text_field',value: 'My Text', type: 'text'}, { field: 'html_field',value: 'html', type: 'html'}]
    expect(response.status).to eq(200)
  end

  it 'will update any existiong fields' do
    expect(@page.contents.first.get).to eq('Old value')
    patch :update, id: @page.to_param, contents: { field: 'existing_text_field',value: 'New value', type: 'text'}
    @page.reload
    expect(@page.get(:existing_text_field)).to eq('New value')
  end

  it 'will allow you to save values that are other than strings' do
    patch :update, id: @page.to_param, contents: { field: 'image_field',value: {url: 'test'}, type: 'image'}
    @page.reload
    expect(@page.get(:image_field)).to eq({'url' => 'test'})
  end

end