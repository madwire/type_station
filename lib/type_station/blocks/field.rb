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
          { cloudinary: (Cloudinary::Utils.sign_request(Cloudinary::Uploader.build_upload_params({}), {}) rescue {}) }
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
