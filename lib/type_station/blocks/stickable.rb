require 'type_station/blocks/base'

module TypeStation
  module Blocks
    class Stickable < Base
      
      private

      def tag_name
        options[:content_tag] || :div
      end

      def tag_class
        options[:class]
      end

      def tag_data
        {}
      end

    end
  end
end