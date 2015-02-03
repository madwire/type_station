require 'type_station/blocks/base'

module TypeStation
  module Blocks
    class EditableText < Base
      
      private

      def tag_name
        options[:content_tag] || :span
      end

      def tag_ts_url
        model.edit_url
      end
      
    end
  end
end