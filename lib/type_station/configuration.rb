require 'active_support/configurable'

module TypeStation
  # Configures global settings for TypeStation
  #   TypeStation.configure do |config|
  #     config.model = User
  #   end
  def self.configure(&block)
    yield @config ||= TypeStation::Configuration.new
  end

  # Global settings for TypeStation
  def self.config
    @config
  end

  class Configuration
    include ActiveSupport::Configurable

    config_accessor :authenticate_with
    config_accessor :authorise_with
    config_accessor :current_user

  end

  configure do |config|
    config.authenticate_with = Proc.new do
      request.env['warden'].try(:authenticate!)
    end
    
    config.authorise_with = Proc.new do
      request.env["warden"].try(:user) || respond_to?(:current_user) && current_user
    end

    config.current_user = Proc.new do
      request.env["warden"].try(:user) || respond_to?(:current_user) && current_user
    end
  end
end
