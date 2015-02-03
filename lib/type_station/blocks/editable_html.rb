require 'type_station/blocks/base'

module TypeStation
  module Blocks
    class EditableHtml < Base

      private

      def tag_ts_url
        model.edit_url
      end

    end
  end
end