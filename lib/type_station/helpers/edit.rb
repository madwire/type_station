require 'type_station/blocks'

module TypeStation
  module Helpers
    module New

      # ts_edit :page, @page, fields: ['title'], content_tag: :span
      # ts_edit collection: 'my_collection', @page, fields: ['title'], content_tag: :span

      def ts_edit(key, model, user_options = {}, &block)
        content = capture(&block)
        type = key.is_a?(Hash) ? key.to_a.first.first : key
        options = { type: type }.merge(user_options)

        if type_station_current_user
          klass ||= "TypeStation::Blocks::Edit#{options[:type].to_s.classify}".constantize
          klass.new(model, key, options).render(content)
        else
          TypeStation::Blocks::Stickable.new(model, key, options).render(content)
        end      
      end

    end
  end
end