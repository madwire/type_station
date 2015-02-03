require 'type_station/blocks/base'

module TypeStation
  module Blocks
    class NewPage < Base

      private

      def tag_data
        super.merge({ts_parent_id: model.to_param, ts_fields: (options[:fields] || ['title'])})
      end

      def tag_ts_url
        model.new_url
      end

    end
  end
end