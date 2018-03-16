module TypeStation
  class AdminController < ::TypeStation::ApplicationController
    protect_from_forgery with: :null_session

    before_action :type_station_authenticate!
    before_action :type_station_authorise!

    private

    def type_station_authenticate!
      instance_eval &TypeStation.config.authenticate_with
    end

    def type_station_authorise!
      instance_eval &TypeStation.config.authorise_with
    end

  end
end
