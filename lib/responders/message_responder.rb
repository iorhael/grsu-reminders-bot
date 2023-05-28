# frozen_string_literal: true

require_relative '../message_sender'
require_relative 'user_authentication'
require 'pry-byebug'

class Responders
  class MessageResponder
    include Responders::UserAuthentication

    attr_reader :message, :bot, :user

    def initialize(options)
      @bot = options[:bot]
      @message = options[:message]
      @user = User.find_or_create_by(uid: message.from.id)
    end

    def respond
      on /^\/start/ do
        authenticate(user)
      end

      on /^\/department (\d*)/ do |department_id|
        binding.pry
        authenticate(user)
      end

      on /^\/faculty (\d*)/ do |faculty_id|
        authenticate(user)
      end

      on /^\/group (\d*)/ do |group_id|
        authenticate(user)
      end

      on /^\/stop/ do
        logout_user
        stop_receiving_messages
        answer_with_stop_message
      end
    end

    private

    def on(regex, &block)
      regex =~ message.text

      if $~
        case block.arity
        when 0
          yield
        when 1
          yield $1
        when 2
          yield $1, $2
        end
      end
    end

    def start_receiving_messages
      user.update(receive_alerts: true)
    end

    def stop_receiving_messages
      user.update(receive_alerts: false)
    end

    def answer_with_start_message
      answer_with_message I18n.t('start_message')
    end

    def answer_with_stop_message
      answer_with_message I18n.t('stop_message')
    end

    def answer_with_message(text)
      MessageSender.new(bot: bot, chat: message.chat, text: text).send
    end
  end
end
