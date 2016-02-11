require 'action_view/helpers/tag_helper'
require "rails/html/sanitizer"

module TypeStation
  module Blocks
    class Base
      include ActionView::Helpers::TagHelper

      attr_reader :authorise, :model, :options

      def initialize(authorise, model, options)
        @sanitizer = Rails::Html::WhiteListSanitizer.new
        @authorise = authorise
        @model = model
        @options = options
      end

      def render(raw_content)
        content = @sanitizer.sanitize(raw_content)

        if showifblock
          render_edit(content)
        else
          render_default(content)
        end
      end

      def data
        {}
      end

      private

      def render_edit(content)
        content_tag(tag_name, content.html_safe, class: tag_class, id: tag_id, data: tag_data)
      end

      def render_default(content)
        if options[:stick].present?
          content_tag(tag_name, content.html_safe, class: tag_class, id: tag_id)
        else
          content.html_safe
        end
      end

      def showifblock
        options[:if] || authorise
      end

      def tag_id
        options[:id] || "#{model.to_param}-#{SecureRandom.hex(3)}"
      end

      def tag_name
        options[:content_tag] || :div
      end

      def tag_class
        options[:class]
      end

      def tag_data
        { ts: data.merge({url: options[:url] }) }
      end

    end
  end
end
