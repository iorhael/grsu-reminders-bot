# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'

require 'pg'
require 'active_record'
require 'yaml'

require 'telegram/bot'
require_relative 'lib/app_configurator'
require_relative 'models/user'

namespace :users do
  desc 'Notify users about movement'
  task :notify, [:filename] do |_, args|
    config = AppConfigurator.new
    config.configure
    bot = Telegram::Bot::Client.new(config.token)

    file_to_send = Faraday::UploadIO.new(args[:filename], 'video/mkv')
    file_caption = "Motion was detected at #{Time.now.getlocal('+03:00')}"

    User.where(receive_alerts: true).each do |user|
      puts "Sending message to #{user.uid}"
      bot.api.send_video(chat_id: user.uid, video: file_to_send, caption: file_caption)
    end
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
