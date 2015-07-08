require 'type_station/blocks/base'

module TypeStation
  module Blocks
    class Entity < Base

      def data
        {
          action: options[:action],
          id: options[:model_id] || model.to_param,
          type: (options[:type] || model._type).to_s.classify,
          parent_id: options[:model_parent_id] || model.parent_id.to_s,
          fields: options[:fields],
          values: model_values,
          create_url: options[:create_url],
          position: model.position,
          options: options[:options] || data_options
        }
      end

      private

      def data_options
        nil
      end

      def render_default(content)
        nil
      end

      def model_values
        values = options[:fields].map do |field|
          content = model.get(field[:name])
          value = content.is_a?(String) || content.is_a?(Symbol) ? content.to_s : content.try(:value)
          if value
            [field[:name], value]
          else
            nil
          end
        end
        Hash[*values.compact.flatten(1)]
      end

    end
  end
end
