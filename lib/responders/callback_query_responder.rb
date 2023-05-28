# frozen_string_literal: true

require_relative 'user_authentication'

class Responders
  class CallbackQueryResponder
    include Responders::UserAuthentication

    attr_reader :message, :bot, :user

    def initialize(options)
      @bot = options[:bot]
      @message = options[:message]
      @user = User.find_or_create_by(uid: message.from.id)
    end

    def respond
      response_data = JSON.parse(message.attributes[:data]).symbolize_keys

      response_data.each do |attribute, value|
        case attribute
        when :department
          update_users_department_id(value) unless user.department
          answer_callback_query(message) do
            authenticate(user)
          end
        when :faculty
          update_users_faculty_id(value) unless user.faculty
          answer_callback_query(message) do
            authenticate(user)
          end
        when :group
          update_users_group_id(value) unless user.group
          answer_callback_query(message) do
            authenticate(user)
          end
        when :notificate
          update_users_notificate(value)
          answer_callback_query(message) do
            edit_settings_message(user, message)
          end
        end
      end
    end

    private

    def answer_callback_query(message)
      bot.api.answer_callback_query(callback_query_id: message.id)
      yield if block_given?
    rescue Telegram::Bot::Exceptions::ResponseError
      puts '[ERROR] Callback was processed to late!'
    end

    def update_users_department_id(department_id)
      user.department_id = department_id
      user.save!
    end

    def update_users_faculty_id(faculty_id)
      user.faculty_id = faculty_id
      user.save!
    end

    def update_users_group_id(group_id)
      user.group_id = group_id
      user.save!
    end

    def update_users_notificate(notificate)
      user.notificate = notificate
      user.save!
    end

    def edit_settings_message(user, message)
      notificate_button_action = user.notificate ? 'Disable' : 'Enable'
      notificate_button_text = "#{notificate_button_action} notifications"

      notificate_state = user.notificate ? 'Enabled' : 'Disabled'
      settings_text = "Bot settings:\nNotifications -> #{notificate_state}"

      kb = [[Telegram::Bot::Types::InlineKeyboardButton.new(text: notificate_button_text, callback_data: { notificate: !user.notificate }.to_json)]]
      reply_markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
      bot.api.edit_message_text(chat_id: message.from.id, message_id: message.message.message_id, text: settings_text, reply_markup: reply_markup)
    end
  end
end
