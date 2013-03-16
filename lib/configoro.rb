raise "Configoro must be used in the context of a Rails 3 application" unless defined?(Rails)

require 'erb'
require 'yaml'
require 'bundler'
Bundler.setup

require 'configoro/base'
require 'configoro/hash'
require 'configoro/railtie'
require "#{File.dirname __FILE__}/../generators/configoro_generator"
