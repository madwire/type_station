module TypeStation
  module ViewHelpers

    def editable(model, key, options = {}, &block)
      result = ''
      presenter = model.try(key)
      type = options[:type] || :text
      id = options[:id] || "#{model.to_param}-#{key}-#{SecureRandom.hex(3)}"
      data = options[:data] || {}

      if presenter.present?
        result += presenter.call(&block)
      else
        result += capture(OpenStruct.new({}), &block)
      end

      if type_station_current_user
        case type
        when :text
          content_tag(:span, result, class: 'ts-editable-text', id: id, data: {ts_id: model.to_param, ts_edit_url: model.edit_url, ts_field: key, ts_data: data})
        when :html
          content_tag(:div, result.html_safe, class: 'ts-editable-html', id: id, data: {ts_id: model.to_param, ts_edit_url: model.edit_url, ts_field: key, ts_data: data})
        when :image, :file
          data = Cloudinary::Utils.sign_request(Cloudinary::Uploader.build_upload_params({}), {}) rescue {}
          content_tag(:div, result.html_safe, class: "ts-editable-#{type}", id: id, data: {ts_id: model.to_param, ts_edit_url: model.edit_url, ts_field: key, ts_data: data })
        when :select
          content_tag(:div, result.html_safe, class: 'ts-editable-select', id: id, data: {ts_id: model.to_param, ts_edit_url: model.edit_url, ts_field: key, ts_data: {}})
        when :multiple_select
          content_tag(:div, result.html_safe, class: 'ts-editable-multiple-select', id: id, data: {ts_id: model.to_param, ts_edit_url: model.edit_url, ts_field: key, ts_data: data})
        end
      else
        result
      end
    end

    def ts_image_tag(identifier, options = {})
      css_class = options.delete(:class) if options.include?(:class)
      cl_image_tag(identifier, options.merge({class: ['ts-editable-image-tag', css_class], data: options}))
    end

    def ts_link_to(identifier, html_options = nil, &block)
      css_class = html_options.delete(:class) if html_options.include?(:class)
      content_tag(:a, nil, html_options.merge({class: ['ts-editable-link-tag', css_class], href: cloudinary_url(identifier)}), &block)
    end

    def type_station_admin_toolbar(model)
      type_station_toolbar('ts-admin-bar', model, 'admin_bar')
    end

    def type_station_init
      result = ''.html_safe
      if type_station_current_user
        result << stylesheet_link_tag("//code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css")
        result << stylesheet_link_tag("type_station/application", media: "all")
        result << javascript_include_tag("type_station/application") 
        result << cloudinary_js_config     
      end
      result
    end

    def type_station_current_user
      instance_eval &TypeStation.config.current_user
    end

    def type_station_toolbar(id, model, partial_name)
      type_station_template([id, 'template'].join('-'), render(partial: "type_station/toolbars/#{partial_name}", locals: {model: model}).html_safe)
    end

    def type_station_template(id, content, type = 'text/x-type-station-template')
      content_tag :script, content, id: id, type: type
    end

  end
end