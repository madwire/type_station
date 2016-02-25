module TypeStation
  class ContentPresenter < BasePresenter
    presents :content

    def tag(default, options = {})
      css_class = options.delete(:class) if options.include?(:class)
      cl_image_tag((content.present? ? content['identifier'] : default), options.merge({class: ['ts-editable-image-tag', css_class], data: options}))
    end

    def link(default, html_options = nil, &block)
      css_class = html_options.delete(:class) if html_options.include?(:class)
      content_tag(:a, nil, html_options.merge({class: ['ts-editable-link-tag', css_class], href: (content.present? ? cloudinary_url(content['identifier'], format: content['format']) : default)}), &block)
    end

    def value_is_hash?
      content.is_a? Hash
    end

    def value
      sanitized_value
    end

    private

    def sanitized_value
      @sanitized_value ||= Rails::Html::WhiteListSanitizer.new.sanitize(content)
    end

  end
end
