require 'type_station/blocks/base'

module TypeStation
  module Blocks
    class EditableImage < Base

      private

      def tag_data
        (super).merge({ts_moveable: @options[:moveable]})
      end

      def tag_class
        puts config
        (super).push(@options[:moveable] ? 'ts-moveable' : nil).compact
      end

      def tag_ts_data
        Cloudinary::Utils.sign_request(Cloudinary::Uploader.build_upload_params({}), {}) rescue {}
      end

      def tag_ts_url
        model.edit_url
      end

    end
  end
end