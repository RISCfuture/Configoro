require 'rubygems'

#################################### BUNDLER ###################################

require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  warn e.message
  warn "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

#################################### JEWELER ###################################

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name        = 'configoro'
  gem.homepage    = 'http://github.com/RISCfuture/configoro'
  gem.license     = 'MIT'
  gem.summary     = %(Configuration object and YAML-based storage for Rails apps)
  gem.description = %(Creates a YourApp::Configuration object whose methods are generated from environment-specific YAML files.)
  gem.email       = 'git@timothymorgan.info'
  gem.authors     = ['Tim Morgan']
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

##################################### RSPEC ####################################

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task default: :spec

##################################### YARD #####################################

require 'yard'
YARD::Rake::YardocTask.new do |doc|
  doc.options << '-m' << 'markdown'
  doc.options << '-M' << 'redcarpet'
  doc.options << '--protected'
  doc.options << '--no-private'
  doc.options << '-r' << 'README.md'
  doc.options << '-o' << 'doc'
  doc.options << '--title' << 'Configoro Documentation'

  doc.files = %w[lib/**/* README.md]
end

desc "Generate API documentation"
task doc: :yard
