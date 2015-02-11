module TypeStation
  module Helpers
    module Utilities

      def ts_page(name)
        PagePresenter.new(TypeStation::Page.find_by_name(name), self)
      end

      def ts_pages(name, parent = nil)
        context = self
        criteria = TypeStation::Page.where(name: name)
        criteria = criteria.where(parent_id: parent.to_param) if parent
        criteria.map {|p| PagePresenter.new(p, context) }
      end

      def ts_init
        result = ''.html_safe
        if type_station_current_user
          result << stylesheet_link_tag("//code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css")
          result << stylesheet_link_tag("type_station/application", media: "all")
          result << javascript_include_tag("type_station/application") 
          result << cloudinary_js_config     
          result << content_tag(:script, "window.TS.ADMIN_PAGES_URL = '#{type_station.admin_pages_url}';".html_safe, type: 'text/javascript')
        end
        result
      end

      def ts_image_tag(identifier, options = {})
        css_class = options.delete(:class) if options.include?(:class)
        cl_image_tag(identifier, options.merge({class: ['ts-editable-image-tag', css_class], data: options}))
      end

      def ts_link_to(identifier, html_options = nil, &block)
        css_class = html_options.delete(:class) if html_options.include?(:class)
        content_tag(:a, nil, html_options.merge({class: ['ts-editable-link-tag', css_class], href: cloudinary_url(identifier)}), &block)
      end

    end
  end
end