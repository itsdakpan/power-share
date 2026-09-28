require_relative "boot"

require "rails/all"

# Pasting secrets from notes apps can add invisible characters (like U+2028) that break the URL.
%w[CLOUDINARY_URL DATABASE_URL].each do |key|
  ENV[key] = ENV[key].gsub(/[[:space:]\u2028\u2029\u200B\uFEFF]/, "") if ENV[key]
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PowerShare
  class Application < Rails::Application
    config.action_controller.raise_on_missing_callback_actions = false if Rails.version >= "7.1.0"
    config.generators do |generate|
      generate.assets false
      generate.helper false
      generate.test_framework :test_unit, fixture: false
    end

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2
    # Images are shown with CSS object-fit, so no image variant processing is needed.
    config.active_storage.variant_processor = :disabled

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
