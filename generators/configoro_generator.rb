require 'rails'
require 'rails/generators'

class ConfigoroGenerator < Rails::Generators::Base
  desc "Installs example configuration files for use with Configoro"

  def create_yaml_files
    create_file "config/environments/common/example.yml",
                { 'common_setting' => true }.to_yaml
    create_file "config/environments/development/example.yml",
                { 'environment_name' => 'Development' }.to_yaml
    create_file "config/environments/test/example.yml",
                { 'environment_name' => 'Test' }.to_yaml
    create_file "config/environments/production/example.yml",
                { 'environment_name' => 'Production' }.to_yaml
  end
end
