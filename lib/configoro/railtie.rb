# Loads the `Configuration` object during the Rails initialization process.

class Configoro::Railtie < Rails::Railtie
  initializer "Configoro", before: :load_config_initializers do
    Configoro.initialize
  end
end
