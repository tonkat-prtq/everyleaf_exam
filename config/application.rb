require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EveryleafExam
  class Application < Rails::Application
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local
    I18n.enforce_available_locales = false
    config.i18n.default_locale = :ja
    config.load_defaults 5.2
    config.generators do |g|
      g.assets false
      g.helper false
      g.jbuilder false
      g.test_framework :rspec,
        model_specs: true,
        view_specs: false, # viewSpecを作成しない
        helper_specs: false, # helperFile用のspecを作成しない
        routing_specs: false, # routes.rb用のspecを作成しない
        controller_specs: false, # controller用のspecを作成しない
        request_specs: false
    end
  end
end
