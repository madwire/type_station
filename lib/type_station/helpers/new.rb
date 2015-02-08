require 'type_station/blocks'

module TypeStation
  module Helpers
    module New

      # ts_new :page, @page, fields: ['title'], content_tag: :span
      # ts_new collection: 'my_collection', @page, fields: ['title'], content_tag: :span

      def ts_new(key, model, user_options = {}, &block)
        content = capture(&block)
        type = key.is_a?(Hash) ? key.to_a.first.first : key
        options = { type: type }.merge(user_options)

        if type_station_current_user
          klass ||= "TypeStation::Blocks::New#{options[:type].to_s.classify}".constantize
          klass.new(model, key, options).render(content)
        else
          nil #dont show anything
        end      
      end

    end
  end
end