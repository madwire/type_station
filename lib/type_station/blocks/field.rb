require 'type_station/blocks/base'

module TypeStation
  module Blocks
    class Field < Base

      def data
        {
          type: options[:type],
          id: model.to_param,
          field:  options[:field],
          options: data_options
        }
      end

      private

      def data_options
        case options[:type]
        when :image, :file
          upload_option = options[:private].present? ? { type: 'private' } : {}
          { cloudinary: (Cloudinary::Utils.sign_request(Cloudinary::Uploader.build_upload_params(upload_option), {}) rescue {}) }
        else
          nil
        end
      end

      def tag_name
        default_tag = options[:type] == :text ? :span : :div
        options[:content_tag] || default_tag
      end

    end
  end
end
