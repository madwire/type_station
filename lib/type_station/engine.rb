require 'mongoid'
require 'mongoid/tree'
require 'jquery-fileupload-rails'
require 'cloudinary'

module TypeStation
  class Engine < ::Rails::Engine
    isolate_namespace TypeStation

    config.to_prepare do
      Dir.glob(Rails.root + "app/helpers/*_helper.rb").each do |helper_path|
        require_dependency(helper_path)
        helper = File.basename(helper_path, ".rb")
        ::TypeStation::ApplicationHelper.send :include, helper.classify.constantize
      end
    end
  end
end
