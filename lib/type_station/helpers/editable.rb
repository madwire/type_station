require 'type_station/blocks'

module TypeStation
  module Helpers
    module Editable
      
      def ts_editable(model, key, user_options = {}, &block)
        content = ''
        options = { type: :text }.merge(user_options)

        presenter = model.try(key)

        if presenter.present?
          if presenter.value.is_a? Hash
            content += capture(OpenStruct.new(presenter.value), &block)
          else
            content += presenter.value
          end
        else
          content += capture(OpenStruct.new({}), &block)
        end

        if type_station_current_user
          klass ||= "TypeStation::Blocks::Editable#{options[:type].to_s.classify}".constantize
          klass.new(model, key, options).render(content)
        else
          content
        end
      end

    end
  end
end