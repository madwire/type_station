$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "type_station/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "type_station"
  s.version     = TypeStation::Version::STRING
  s.authors     = ["Richard Adams"]
  s.email       = ["richard@madwire.co.uk"]
  s.homepage    = "http://madwire.co.uk"
  s.summary     = "A Simple Content Management System."
  s.description = "A simple CMS that just works and can be bolted onto a rails app with easy."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", '~> 4.2', ">= 4.2.0"
  s.add_dependency "mongoid", '~> 4.0', ">= 4.0.0"
  s.add_dependency "mongoid-tree", '~> 2.0', ">= 2.0.0"
  s.add_dependency "jquery-fileupload-rails", '~> 0.4', ">= 0.4.3"
  s.add_dependency 'cloudinary', '~> 1.0', ">= 1.0.81"
  s.add_dependency "coffee-rails", '~> 4.1', ">= 4.1.0"
  s.add_dependency "haml-rails", '~> 0.0', ">= 0.7.0"

  s.add_development_dependency "rspec", '~> 3.1'
  s.add_development_dependency 'rspec-rails', '~> 3.0', '>= 3.0'
  s.add_development_dependency "guard-rspec", '~> 4.3', ">= 4.3.1"
  s.add_development_dependency 'shoulda-matchers', '~> 2.7', ">= 2.7.0"
  s.add_development_dependency "database_cleaner", "~> 1.4", ">= 1.4.0"
end
