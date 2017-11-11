require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AppMysql
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.assets.paths << "#{Rails.root}/lib/assets"
    
    Koala.config.api_version = 'v2.10'

    config.generators do |g|
      g.assets false
    end
  end
end

module ApplicationConstant
  # Database user_component_cms
  COMPONENT_CMS = 1  

  DISPLAY = 1
end

module CMSConstant

  PREFIX_MENU_NAME = 'name'

  PREFIX_MENU_URL = 'url'

end
