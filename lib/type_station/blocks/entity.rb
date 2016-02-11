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
          fields: model_fields,
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

      def model_fields
        lambda_binging = Struct.new(:model).new(model)
        options[:fields].map do |field|
          if field[:options] && field[:options].is_a?(Proc)
            field[:options] = lambda_binging.instance_exec(&field[:options])
          end
          field
        end
      end

      def model_values
        values = options[:fields].map do |field|
          content = model.get(field[:name])
          raw_value = content.respond_to?(:value) ? content.value : content.to_s
          if raw_value
            value = @sanitizer.sanitize(raw_value)
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
