$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'bundler'
Bundler.require :development

require 'yaml'
Bundler.setup

require 'configoro'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|
  config.before :each do
    application = instance_double('Rails::Application', class: 'MyApp::Application')
    Object.send :remove_const, :Rails
    ::Rails = class_double('Rails', application: application, env: 'development', root: File.join(File.dirname(__FILE__), 'data'))
    Configoro.initialize
  end
end
