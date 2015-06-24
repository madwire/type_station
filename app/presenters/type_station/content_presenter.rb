module TypeStation
  class ContentPresenter < BasePresenter
    presents :content

    def tag(default, options = {})
      css_class = options.delete(:class) if options.include?(:class)
      if value.present?
        cl_image_tag(value['identifier'], options.merge({class: ['ts-editable-image-tag', css_class], data: options}))
      else
        image_tag(default, options.merge({class: ['ts-editable-image-tag', css_class], data: options}))
      end
    end

    def link(default, html_options = nil, &block)
      css_class = html_options.delete(:class) if html_options.include?(:class)
      content_tag(:a, nil, html_options.merge({class: ['ts-editable-link-tag', css_class], href: (value.present? ? cloudinary_url(value['identifier']) : default)}), &block)
    end

    def value
      content
    end

  end
end
