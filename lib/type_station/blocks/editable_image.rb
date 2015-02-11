require 'type_station/blocks/base'

module TypeStation
  module Blocks
    class EditableImage < Base

      private

      def tag_data
        data = super
        data.merge!({ts_moveable: @options[:moveable]}) if @options[:moveable]
        data.merge!({ts_moveable_distance: moveable_ancestor_level}) if @options[:ancestor_distance]
      end

      def tag_class
        (super).push(@options[:moveable] ? 'ts-moveable' : nil).compact
      end

      def tag_ts_data
        Cloudinary::Utils.sign_request(Cloudinary::Uploader.build_upload_params({}), {}) rescue {}
      end

      def tag_ts_url
        model.edit_url
      end

      def moveable_ancestor_level
        @options[:ancestor_distance] || 1
      end

    end
  end
end