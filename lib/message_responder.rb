# frozen_string_literal: true

require_relative '../models/user'
require_relative 'message_sender'

class MessageResponder
  attr_reader :message, :bot, :user

  def initialize(options)
    @bot = options[:bot]
    @message = options[:message]
    @user = User.find_or_create_by(uid: message.from.id)
  end

  def respond
    on /^\/start/ do
      start_receiving_messages
      answer_with_start_message
    end

    on /^\/stop/ do
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
