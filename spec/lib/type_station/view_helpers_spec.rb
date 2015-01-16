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
    end

    describe 'none Admin mode' do

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

      it 'will render the default text value' do
        helper.inline_edit_js
        value = helper.editable @presenter, :title_test do
          'Test'
        end
        result = content_tag(:span, "Test", class: 'ts-editable-text', data: {ts_id: @presenter.to_param, ts_edit_url: @presenter.edit_url, ts_field: :title_test})
        expect(value).to eq(result)
      end

      it 'will render the default html value' do
        helper.inline_edit_js
        value = helper.editable @presenter, :body, type: :html do
          '<h1>Test</h1>'.html_safe
        end
        result = content_tag(:div,'<h1>Test</h1>', class: 'ts-editable-html', data: {ts_id: @presenter.to_param, ts_edit_url: @presenter.edit_url, ts_field: :body})
        expect(value).to eq(result)
      end

      it 'will render the default image value' do
        helper.inline_edit_js
        value = helper.editable @presenter, :image, type: :image do |image|
          image.url || "http://placehold.it/350x150"
        end
        result = content_tag(:div,'http://placehold.it/350x150', class: 'ts-editable-image', data: {ts_id: @presenter.to_param, ts_edit_url: @presenter.edit_url, ts_field: :image})
        expect(value).to eq(result)
      end

      it 'will render the default select value' do
        helper.inline_edit_js
        value = helper.editable @presenter, :select, type: :select do |multiple_select|
          multiple_select.values || "Other"
        end
        result = content_tag(:div,'Other', class: 'ts-editable-select', data: {ts_id: @presenter.to_param, ts_edit_url: @presenter.edit_url, ts_field: :select})
        expect(value).to eq(result)
      end

      it 'will render the default multiple_select value' do
        helper.inline_edit_js
        value = helper.editable @presenter, :multiple_select, type: :multiple_select do |multiple_select|
          multiple_select.values || "Other"
        end
        result = content_tag(:div,'Other', class: 'ts-editable-multiple-select', data: {ts_id: @presenter.to_param, ts_edit_url: @presenter.edit_url, ts_field: :multiple_select})
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
    end

    describe 'none Admin mode' do

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