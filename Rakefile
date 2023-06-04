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

desc 'Configure environment'
task :environment do
  AppConfigurator.new.configure
end

desc 'Annotate models'
task :annotate do
  require 'annotate'

  Annotate.set_defaults('models' => 'true', 'model_dir' => 'models')
  Annotate.load_tasks
  Rake::Task['annotate_models'].invoke
end

desc 'Open console with all loaded dependencies'
task :console do
  config = AppConfigurator.new
  config.configure
  bot = Telegram::Bot::Client.new(config.token)
  binding.pry # rubocop:disable Lint/Debugger
end
task c: :console

namespace :schedule do
  desc 'Update whole schedule'
  task :get do
    config = AppConfigurator.new
    config.configure
    bot = Telegram::Bot::Client.new(config.token)

    Data::Updater.new(bot).call
  end
end

namespace :db do
  desc 'Migrate the database'
  task :migrate do
    connection_details = YAML.load(File.open('config/database.yml'))
    ActiveRecord::Base.establish_connection(connection_details)
    ActiveRecord::MigrationContext.new('db/migrate').migrate

    Rake::Task['annotate'].invoke
  end

  desc 'Create the database'
  task :create do
    connection_details = YAML.load(File.open('config/database.yml'))
    admin_connection = connection_details.merge({ 'database' => 'postgres',
                                                  'schema_search_path' => 'public' })
    ActiveRecord::Base.establish_connection(admin_connection)
    ActiveRecord::Base.connection.create_database(connection_details.fetch('database'))
  end

  desc 'Drop the database'
  task :drop do
    connection_details = YAML.load(File.open('config/database.yml'))
    admin_connection = connection_details.merge({ 'database' => 'postgres',
                                                  'schema_search_path' => 'public' })
    ActiveRecord::Base.establish_connection(admin_connection)
    ActiveRecord::Base.connection.drop_database(connection_details.fetch('database'))
  end
end
