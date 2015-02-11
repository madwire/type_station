require 'type_station/blocks/base'

module TypeStation
  module Blocks
    class EditPage < Base

      private

      def tag_data
        super.merge({ts_fields: (options[:fields] || [{name: :title, type: 'text', label: 'Page Title'}])})
      end

      def tag_ts_url
        model.edit_url
      end

      def tag_ts_data
        values = options[:fields].map do |field| 
          content = model.try(field[:name])
          [field[:name], content.is_a?(String) ? content : content.try(:value)]
        end
        super.merge({ts_values: Hash[*values.flatten], ts_position: model.position })
      end

    end
  end
end