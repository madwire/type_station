require 'type_station/view_helpers'

module TypeStation
  class Railtie < Rails::Railtie
    initializer "type_station.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end
  end
end