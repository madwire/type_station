module TypeStation
  module ViewHelpers

    def editable(model, key, options = {}, &block)
      result = ''
      presenter = model.try(key)
      type = options[:type] || :text

      if presenter.present?
        result += presenter.call(&block)
      else
        result += capture(OpenStruct.new({}), &block)
      end

      if type_station_current_user
        case type
        when :text
          content_tag(:span, result, class: 'ts-editable-text', id: "#{model.to_param}-#{key}", data: {ts_id: model.to_param, ts_edit_url: model.edit_url, ts_field: key})
        when :html
          content_tag(:div, result.html_safe, class: 'ts-editable-html', id: "#{model.to_param}-#{key}", data: {ts_id: model.to_param, ts_edit_url: model.edit_url, ts_field: key})
        when :image
          content_tag(:div, result, class: 'ts-editable-image', data: {ts_id: model.to_param, ts_edit_url: model.edit_url, ts_field: key})
        when :select
          content_tag(:div, result, class: 'ts-editable-select', data: {ts_id: model.to_param, ts_edit_url: model.edit_url, ts_field: key})
        when :multiple_select
          content_tag(:div, result, class: 'ts-editable-multiple-select', data: {ts_id: model.to_param, ts_edit_url: model.edit_url, ts_field: key})
        end
      else
        result
      end
    end

    def inline_edit_js
      result = ''.html_safe
      if type_station_current_user
      # TODO INIT JS
        result << type_station_toolbar('ts-editable-text-toolbar', 'text')
      end
      result
    end

    def type_station_current_user
      instance_eval &TypeStation.config.current_user
    end

    def type_station_toolbar(id, partial_name = 'text')
      type_station_template(id, render(partial: "type_station/toolbars/#{partial_name}").html_safe)
    end

    def type_station_template(id, content)
      content_tag :script, content, id: id, type: 'text/x-type-station-template'
    end

  end
end