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

      on /^\/logout/ do
        logout(user)
        respond_with_logout_message
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

    def logout(user)
      User::Logouter.new(user).call
    end

    def respond_with_logout_message
      answer_with_message('Have a great day! Thanks for using our bot!')
    end

    def answer_with_message(text)
      MessageSender.new(bot: bot, chat: message.chat, text: text).send
    end
  end
end
