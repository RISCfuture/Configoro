unless defined?(Rails)
  raise "Configoro must be run in the context of a Rails environment, or require 'configoro/simple' outside of Rails"
end

require 'erb'
require 'yaml'

require 'bundler'
Bundler.setup

require 'active_support/hash_with_indifferent_access'
require 'active_support/core_ext/hash/deep_merge'

load 'configoro/base.rb'

module Configoro

  # undo anything done by configoro/simple...
  begin
    remove_const :Hash
    remove_const :HashWithIndifferentAccess
  rescue NameError
    # ignored
  end
end
load 'configoro/hash.rb'

load 'configoro/railtie.rb'
load "#{File.dirname __FILE__}/../generators/configoro_generator.rb"
