module TypeStation
  module Concerns
    module Templatable
      extend ActiveSupport::Concern

      included do
        field :template_name, type: String, default: 'undefined'
      end

      def template_name?
        template_name.present? && template_name != 'undefined'
      end

    end
  end
end
