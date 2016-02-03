module TypeStation
  module ViewHelpers

    def present(object, klass = nil, &block)
      if object.present?
        klass ||= "#{object.class.to_s}Presenter".constantize
        block.call(klass.new(object, self))
      else
        nil
      end
    end

    def ts_init
      result = ''.html_safe
      if type_station_authorise
        result << stylesheet_link_tag("//code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css")
        result << stylesheet_link_tag("type_station/application", media: "all")
        result << javascript_include_tag("type_station/application")
        result << cloudinary_js_config
      end
      result
    end

    def ts_admin_toolbar(model, options = {})
      type_station_toolbar('ts-admin-bar', model, 'admin_bar', options) if type_station_authorise
    end

    def type_station_current_user
      instance_eval &TypeStation.config.current_user
    end

    def type_station_authorise
      instance_eval &TypeStation.config.authorise_with
    end

    def type_station_toolbar(id, model, partial_name, options = {})
      type_station_template([id, 'template'].join('-'), sanitize(render(partial: "type_station/toolbars/#{partial_name}", locals: {model: model, options: options})).html_safe)
    end

    def type_station_template(id, content, type = 'text/x-type-station-template')
      content_tag :script, content, id: id, type: type
    end

  end
end
