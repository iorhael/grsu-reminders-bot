# frozen_string_literal: true

require_relative '../models/user'
require_relative 'message_sender'
require 'pry-byebug'

class MessageResponder
  attr_reader :message, :bot, :user

  def initialize(options)
    @bot = options[:bot]
    @message = options[:message]
    @user = User.find_or_create_by(uid: message.from.id)
  end

  def respond
    on /^\/start/ do
      process_user_message

    end

    on /^\/department (\d*)/ do |department_id|
      binding.pry
      process_user_message
    end

    on /^\/faculty (\d*)/ do |faculty_id|
      process_user_message
    end

    on /^\/group (\d*)/ do |group_id|
      process_user_message
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

  def process_user_message
    choose_department #unless user.department
    # choose_faculty unless user.faculty
    # choose_group unless user.group
  end

  def choose_department
    binding.pry
    kb = []
    ::Department.all.each do |department|
      kb.push([Telegram::Bot::Types::InlineKeyboardButton.new(text: department.title, callback_data: "department #{department.id}")])
    end
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
    bot.api.send_message(chat_id: message.chat.id, text: 'Choose department', reply_markup: markup)
  end

  def choose_faculty

  end

  def choose_group

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
