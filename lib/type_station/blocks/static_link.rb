require 'type_station/blocks/base'

module TypeStation
  module Blocks
    class StaticLink < Base

      def render(content)
        content_tag(tag_name, content.html_safe, class: tag_class, href: href)
      end
      
      private

      def tag_name
        options[:content_tag] || :a
      end

      def tag_class
        options[:class]
      end

      def tag_data
        {}
      end

      def href 
        model.try(key).try(:value) || options[:default] || '#nolink'
      end

    end
  end
end