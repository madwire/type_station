module TypeStation
  class AdminController < ::TypeStation::ApplicationController
    protect_from_forgery with: :null_session

    before_filter :type_station_authenticate!
    before_filter :type_station_authorise!

    def type_station_authenticate!
      instance_eval &TypeStation.config.authenticate_with
    end

    def type_station_authorise!
      instance_eval &TypeStation.config.authorise_with
    end

    def type_station_current_user
      instance_eval &TypeStation.config.current_user
    end
    
  end
end