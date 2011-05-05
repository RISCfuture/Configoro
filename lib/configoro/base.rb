# This module handles initialization of the Configoro object, and contains some
# utility methods.

module Configoro

  # @return [Module] The Rails application namespace; e.g., @MyApp@ for a Rails
  #   app named @MyApp::Application@.

  def self.namespace
    Object.const_get Rails.application.class.to_s.split('::').first
  end

  # Creates the configuration dictionary and stores it under
  # @MyApp::Configuration@ (assuming an application named @MyApp@).

  def self.initialize
    namespace.const_set :Configuration, build_hash(Rails.env)
  end

  private

  def self.build_hash(env)
    config = Hash.new

    load_data config, 'common'
    load_data config, env

    config
  end

  def self.load_data(config, env)
    Dir.glob("#{Rails.root}/config/environments/#{env}/*.yml").sort.each { |file| config << file }
  end
end
