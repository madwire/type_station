require "type_station/engine"
require "type_station/configuration"
require "type_station/railtie"


module TypeStation

  # Base class for all TypeStation exceptions
  class TypeStationError < StandardError
  end

  class PageNotFoundError < TypeStationError
  end

  class PageTemplateNameUndefined<  TypeStationError
  end

end
