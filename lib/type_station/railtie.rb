require 'type_station/view_helpers'
require 'type_station/concerns'
require 'type_station/blocks'

module TypeStation
  class Railtie < Rails::Railtie
    initializer "type_station.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end
  end
end
