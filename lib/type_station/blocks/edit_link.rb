require 'type_station/blocks/base'

module TypeStation
  module Blocks
    class EditLink < Base
      
      def render(content)
        href = tag_ts_data[:ts_values][tag_ts_data[:ts_values].keys[0]]
        content_tag(tag_name, content.html_safe, class: tag_class, id: tag_id, data: tag_data, href: href)
      end

      private

      def tag_name
        options[:content_tag] || :a
      end

      def tag_ts_url
        model.edit_url
      end

      def tag_ts_data
        fields = options[:fields] || [:url]
        values = options[:fields].map do |field| 
          content = model.try(field[:name])
          [field[:name], content.is_a?(String) ? content : content.try(:value)]
        end
        super.merge({ts_values: Hash[*values.flatten]})
      end
      
    end
  end
end