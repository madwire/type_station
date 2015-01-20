require 'spec_helper'

RSpec.describe TypeStation::ViewHelpers do
  include RSpec::Rails::HelperExampleGroup
  
  describe 'Emtpy without any values' do

    before do
      @root = TypeStation::Page.create(title: 'Test Index')
      @page = TypeStation::Page.create(title: 'Test Page', parent: @root)

      view_context = Struct.new(:test) do
        def edit_admin_page_url(page)
          'URL'  
        end
      end

      @presenter = TypeStation::PagePresenter.new @page, view_context.new
      allow(@presenter).to receive(:edit_url).and_return("URL")
    end

    describe 'none Admin mode' do

      before do
        allow(helper).to receive(:type_station_current_user).and_return(false)
      end

      it 'will render the default text value' do
        value = helper.editable @presenter, :title_test do
          'Test'
        end
        expect(value).to eq('Test')
      end

      it 'will render the default html value' do
        value = helper.editable @presenter, :body, type: :html do
          '<h1>Test</h1>'.html_safe
        end
        expect(value).to eq('<h1>Test</h1>')
      end

      it 'will render the default image value' do
        value = helper.editable @presenter, :image, type: :image do |image|
          image.url || "http://placehold.it/350x150"
        end
        expect(value).to eq('http://placehold.it/350x150')
      end

      it 'will render the default multiple_select value' do
        value = helper.editable @presenter, :multiple_select, type: :multiple_select do |multiple_select|
          multiple_select.values || "Other"
        end
        expect(value).to eq('Other')
      end

    end

    describe 'Inline edit' do

      before do
        allow(helper).to receive(:type_station_current_user).and_return({})
      end

      it 'will render the default text value' do
        value = helper.editable @presenter, :title_test, id: 'test' do
          'Test'
        end
        result = content_tag(:span, "Test", id: 'test', class: 'ts-editable-text', data: {ts_id: @presenter.to_param, ts_edit_url: @presenter.edit_url, ts_field: :title_test, ts_data:{} })
        expect(value).to eq(result)
      end

      it 'will render the default html value' do
        value = helper.editable @presenter, :body, type: :html, id: 'test' do
          '<h1>Test</h1>'.html_safe
        end
        result = content_tag(:div,'<h1>Test</h1>'.html_safe, id: 'test', class: 'ts-editable-html', data: {ts_id: @presenter.to_param, ts_edit_url: @presenter.edit_url, ts_field: :body, ts_data:{} })
        expect(value).to eq(result)
      end

      it 'will render the default image value' do
        value = helper.editable @presenter, :image, type: :image, id: 'test' do |image|
          image.url || "http://placehold.it/350x150"
        end
        result = content_tag(:div,'http://placehold.it/350x150', id: 'test', class: 'ts-editable-image', data: {ts_id: @presenter.to_param, ts_edit_url: @presenter.edit_url, ts_field: :image, ts_data:{} })
        expect(value).to eq(result)
      end

      it 'will render the default select value' do
        value = helper.editable @presenter, :select, type: :select, id: 'test' do |multiple_select|
          multiple_select.values || "Other"
        end
        result = content_tag(:div,'Other', id: 'test', class: 'ts-editable-select', data: {ts_id: @presenter.to_param, ts_edit_url: @presenter.edit_url, ts_field: :select, ts_data:{} })
        expect(value).to eq(result)
      end

      it 'will render the default multiple_select value' do
        value = helper.editable @presenter, :multiple_select, type: :multiple_select, id: 'test' do |multiple_select|
          multiple_select.values || "Other"
        end
        result = content_tag(:div,'Other', id: 'test', class: 'ts-editable-multiple-select', data: {ts_id: @presenter.to_param, ts_edit_url: @presenter.edit_url, ts_field: :multiple_select, ts_data:{} })
        expect(value).to eq(result)
      end

    end

  end

  describe 'With values' do

    before do
      @root = TypeStation::Page.create(title: 'Test Index')
      @page = TypeStation::Page.create(title: 'Test Page', parent: @root)
      @content_text = @page.contents.build(name: :title_test, type: :text)
      @content_text.set('My Text')
      @content_html = @page.contents.build(name: :body, type: :html)
      @content_html.set('<h1>My Text</h1>')
      @content_image = @page.contents.build(name: :image, type: :image)
      @content_image.set({url: 'test', alt: 'Blah', 'string_url' => 'string_test'})
      @content_select = @page.contents.build(name: :select, type: :select)
      @content_select.set('test')
      @content_multiple_select = @page.contents.build(name: :multiple_select, type: :multiple_select)
      @content_multiple_select.set('test, blah')
      @page.save!
      view_context = Struct.new(:test) do
        def edit_admin_page_url(page)
          'URL'  
        end
      end

      @presenter = TypeStation::PagePresenter.new @page, view_context.new
      allow(@presenter).to receive(:edit_url).and_return("URL")
    end

    describe 'none Admin mode' do

      before do
        allow(helper).to receive(:type_station_current_user).and_return(false)
      end

      it 'will render the text value' do
        value = helper.editable @presenter, :title_test do
          'Test'
        end
        expect(value).to eq('My Text')
      end

      it 'will render the html value' do
        value = helper.editable @presenter, :body, type: :html do
          '<h1>Test</h1>'.html_safe
        end
        expect(value).to eq('<h1>My Text</h1>')
      end

      it 'will render the image value' do
        value = helper.editable @presenter, :image, type: :image do |image|
          image.string_url || "http://placehold.it/350x150"
        end
        expect(value).to eq('string_test')
      end

      it 'will render the select value' do
        value = helper.editable @presenter, :select, type: :select do |select|
          select
        end
        expect(value).to eq('test')
      end

      it 'will render the multiple_select value' do
        value = helper.editable @presenter, :multiple_select, type: :multiple_select do |multiple_select|
          multiple_select.join('-')
        end
        expect(value).to eq('test-blah')
      end

    end


  end

  
end