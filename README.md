Configoro
=========

**Environment-specific configuration data for Rails apps**

| **Author** | Tim Morgan |
| **License** | Released under the MIT license. |

About
-----

Pretty much every Rails app out there needs to store environment-specific
configuration data: API URLs, Memcache settings, AWS keys, etc. The "quick fix"
approach is usually to dump this information in, e.g., `development.rb` as
constants, like `MAILCHIMP_API_URL`. This creates cluttered and unorganized
environment files.

Configoro creates a configuration object that can be accessed as both a hash and
struct. It stores common configuration data merged with environment-specific
data.

The data is read from YAML files stored alongside the environment files.

Installation
------------

To use this gem, simply add

```` ruby
gem 'configoro'
````

to your Gemfile, then run

```` ruby
rails generate configoro
````

to install some default configuration files. Edit these new files with your
configuration data.

Usage
-----

Assume your application namespace is `MyApp` (which is what it
would be if you had created your Rails project using `rails new my_app`). You
can find your namespace in your `config/application.rb` file.

In this case, you would access your configuration using the
`MyApp::Configuration` object. You can access it as an indifferent hash

```` ruby
MyApp::Configuration[:mailchimp_api_url]
MyApp::Configuration['mailchimp_api_url']
````

or as a struct.

```` ruby
MyApp::Configuration.mailchimp_api_url
````

If you include any hashes in your configuration YAML files, they will also be
accessible as indifferent hashes or structs:

```` ruby
MyApp::Configuration.memcache.timeout
MyApp::Configuration[:memcache]['timeout']
MyApp::Configuration['memcache'].timeout
````

Configuration Files
-------------------

Configuration is stored within the `config/environments` directory of your Rails
app. Files ending in ".yml" are loaded from the `common/` subdirectory and a
subdirectory named after the current environment.

Configuration files are preprocessed as ERB, in the same way that Rails
preprocesses `config/database.yml`. This allows dynamic configuration,
e.g. `host: <%= ENV["DB_HOST"] || "localhost" %>`.

Each file goes into its own hash in the configuration. For example, if you
placed a file called `memcache.yml` within `config/environments/development`,
you would be able to access your Memcache timeout using
`MyApp::Configuration.memcache.timeout`.

h3. Custom Configuration Locations

If you need to do your own configuration loading, you can do so using the
{Configoro::Hash#<<} method. For example, you could place the following in a
Ruby file under `config/initializers`:

```` ruby
MyApp::Configuration << "path/to/additional/yaml_file.yml"
MyApp::Configuration << { 'additional' => 'configuration' }

MyApp::Configuration.additional #=> 'configuration'
````

Note that if you pass a path to a YAML file, a key will be created to store the
contents of the file, named after the file name. If the key already exists, the
new values will be deep-merged into the existing values.

In the example above, the data in the `yaml_file.yml` file can be accessed using
`MyApp::Configuration.yaml_file`.

Other Notes
-----------

If you want to use Configoro outside of Rails or your gemset, you can require
the `configoro/simple` file. This file defines a subset of the `Configoro`
object you can use to access your configuration. You will need to set
{Configoro.paths} manually, and the `Configoro::Hash` object will have the same
functionality as a normal Hash, without all the bells and whistles described
above.

If you then "upgrade" your environment to a full-fledged Rails or gem-ified
environment (perhaps by running your app's `environment.rb` file, be sure to
run {Configoro.reset_paths} before requiring the `configoro` gem file.
