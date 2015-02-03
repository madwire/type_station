# will/should load the files in the directory!
Dir[File.dirname(__FILE__) + "/helpers/*.rb"].each {|f| require f }