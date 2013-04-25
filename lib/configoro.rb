in_rails = defined?(Rails)

require 'erb'
require 'yaml'

if in_rails
  require 'bundler'
  Bundler.setup
end

require 'configoro/base'
require 'configoro/hash'

if in_rails
  require 'configoro/railtie'
  require "#{File.dirname __FILE__}/../generators/configoro_generator"
end
