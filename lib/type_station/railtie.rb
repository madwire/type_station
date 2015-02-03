require 'type_station/view_helpers'
require 'type_station/helpers'

module TypeStation
  class Railtie < Rails::Railtie
    initializer "type_station.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
      ActionView::Base.send :include, Helpers::New
      ActionView::Base.send :include, Helpers::Editable
      ActionView::Base.send :include, Helpers::Utilities
    end
  end
end