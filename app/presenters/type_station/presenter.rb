require 'type_station/blocks'

module TypeStation
  class Presenter < BasePresenter

    class << self
      attr_accessor :form_fields

      def form_field(name, options)
        @form_fields ||= []
        @form_fields << {name: name, type: options[:type].to_s, label: options[:label], options: options[:options], default: options[:default], required: options[:required]}
      end
    end

  end
end
