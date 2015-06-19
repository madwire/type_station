module TypeStation
  class ApplicationController < ActionController::Base
    rescue_from TypeStation::PageNotFoundError, :with => :page_not_found

    private

    def type_station_current_user
      instance_eval &TypeStation.config.current_user
    end

    def page_not_found
      render file: "#{Rails.root}/public/404.html", layout: false, status: 404 and return
    end

  end
end
