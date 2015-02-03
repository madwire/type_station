require 'action_view/helpers/tag_helper'

module TypeStation
  module Blocks
    class Base
      include ActionView::Helpers::TagHelper

      attr_reader :model, :key, :options

      def initialize(model, key, options)
        @model = model
        @key = key
        @options = options
      end

      def render(content)
        content_tag(tag_name, content.html_safe, class: tag_class, id: tag_id, data: tag_data)
      end

      private

      def tag_id
        options[:id] || "#{model.to_param}-#{key}-#{SecureRandom.hex(3)}"
      end

      def tag_data
        {ts_id: tag_ts_id, ts_url: tag_ts_url, ts_key: key, ts_data: tag_ts_data}
      end

      def tag_name
        options[:content_tag] || :div
      end

      def tag_class
        options[:class] || ['ts', self.class.to_s.demodulize.underscore.dasherize].join('-')
      end

      def tag_ts_data
        (options[:data] || {})
      end

      def tag_ts_id
        model.to_param
      end

      def tag_ts_url
        nil
      end
      
    end
  end
end