$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'bundler'
Bundler.require :development

require 'yaml'
Bundler.setup

require 'configoro'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.before :each do
    application = double('Rails.application', :class => 'MyApp::Application')
    ::Rails = double('Rails', :application => application, :env => 'development', :root => File.join(File.dirname(__FILE__), 'data'))
    Configoro.initialize
  end
end
