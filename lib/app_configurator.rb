# frozen_string_literal: true

require 'logger'
require 'json'

require_relative 'database_connector'

class AppConfigurator
  def configure
    setup_i18n
    setup_database
    load_dependecies
  end

  def token
    YAML.load(IO.read('config/secrets.yml'))['telegram_bot_token']
  end

  def logger
    Logger.new($stdout, Logger::DEBUG)
  end

  private

  def setup_i18n
    I18n.load_path = Dir['config/locales.yml']
    I18n.locale = :en
    I18n.backend.load_translations
  end

  def setup_database
    DatabaseConnector.establish_connection
  end

  def load_dependecies
    Dir.glob(File.join('models', '**', '*.rb'), &method(:require_relative))
    Dir.glob(File.join('services', '**', '*.rb'), &method(:require_relative))
    Dir.glob(File.join('lib', '**', '*.rb'), &method(:require_relative))
  end
end
