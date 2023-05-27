# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'

require 'pg'
require 'active_record'
require 'active_support'
require 'yaml'

require 'pry-byebug'

require 'telegram/bot'
require_relative 'lib/app_configurator'
Dir.glob(File.join('models', '**', '*.rb'), &method(:require_relative))
Dir.glob(File.join('services', '**', '*.rb'), &method(:require_relative))

namespace :shedule do
  desc 'Update whole scedule'
  task :get do
    config = AppConfigurator.new
    config.configure
    bot = Telegram::Bot::Client.new(config.token)

    Data::Updater.new.call
  end
end

namespace :db do
  desc 'Migrate the database'
  task :migrate do
    connection_details = YAML.load(File.open('config/database.yml'))
    ActiveRecord::Base.establish_connection(connection_details)
    ActiveRecord::MigrationContext.new('db/migrate').migrate
  end

  desc 'Create the database'
  task :create do
    connection_details = YAML.load(File.open('config/database.yml'))
    admin_connection = connection_details.merge({'database'=> 'postgres',
                                                'schema_search_path'=> 'public'})
    ActiveRecord::Base.establish_connection(admin_connection)
    ActiveRecord::Base.connection.create_database(connection_details.fetch('database'))
  end

  desc 'Drop the database'
  task :drop do
    connection_details = YAML.load(File.open('config/database.yml'))
    admin_connection = connection_details.merge({'database'=> 'postgres',
                                                'schema_search_path'=> 'public'})
    ActiveRecord::Base.establish_connection(admin_connection)
    ActiveRecord::Base.connection.drop_database(connection_details.fetch('database'))
  end
end
