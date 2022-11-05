# frozen_string_literal: true

require_relative 'reply_markup_formatter'
require_relative 'app_configurator'

class MessageSender
  attr_reader :bot, :text, :chat, :answers, :logger

  def initialize(bot:, text:, chat:, answers: nil)
    @bot = bot
    @text = text
    @chat = chat
    @answers = answers
    @logger = AppConfigurator.new.logger
  end

  def send
    if reply_markup
      bot.api.send_message(chat_id: chat.id, text: text, reply_markup: reply_markup)
    else
      bot.api.send_message(chat_id: chat.id, text: text)
    end

    logger.debug "sending '#{text}' to #{chat.username}"
  end

  private

  def reply_markup
    ReplyMarkupFormatter.new(answers).call if answers
  end
end
