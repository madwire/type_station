require 'type_station/blocks/base'

module TypeStation
  module Blocks
    class EditLink < Base
      
      def render(content)
        content_tag(tag_name, content.html_safe, class: tag_class, id: tag_id, data: tag_data, href: href)
      end

      private

      def tag_name
        options[:content_tag] || :a
      end

      def tag_ts_url
        model.edit_url
      end

      def href 
        model.try(key).try(:value) || options[:default] || '#nolink'
      end
      
    end
  end
end