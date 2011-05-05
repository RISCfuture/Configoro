# Loads the @Configuration@ object during the Rails initialization process.

class Configoro::Railtie < Rails::Railtie
  initializer "Configoro" do
    Configoro.initialize
  end
end
