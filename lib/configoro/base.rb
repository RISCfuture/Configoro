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

  # The search paths Configoro uses to locate configuration files. By default
  # this list contains one item, `RAILS_ROOT/config/environments`. You can edit
  # this list to add your own search paths. Any such paths should have
  # subdirectories for each environment, and `common`, as expected by Configoro.
  #
  # Be sure to add paths before the Configoro initializer is called (see the
  # example).
  #
  # Paths are processed in the order they appear in this array.
  #
  # @return [Array<String>] An editable array of search paths.
  #
  # @example Adding additional paths (application.rn)
  #   config.before_initialize do
  #     Configoro.paths << '/my/custom/path'
  #   end

  def self.paths
    @paths ||= ["#{Rails.root}/config/environments"]
  end

  private

  def self.build_hash(env)
    config = Hash.new
    load_data config, env
    config
  end

  def self.load_data(config, env)
    paths.each do |path|
      Dir.glob("#{path}/common/*.yml").sort.each { |file| config << file }
      Dir.glob("#{path}/#{env}/*.yml").sort.each { |file| config << file }
    end
  end
end
