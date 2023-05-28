# frozen_string_literal: true

class Responders
  module UserAuthentication
    private

    def authenticate(user)
      return choose_department unless user.department
      return choose_faculty unless user.faculty
      return choose_group unless user.group

      send_welcome_message
    end

    def choose_department
      kb = ::Department.required.all.map do |department|
        [Telegram::Bot::Types::InlineKeyboardButton.new(text: department.title, callback_data: { department: department.id }.to_json)]
      end
      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
      bot.api.send_message(chat_id: chat_id, text: 'Choose department', reply_markup: markup)
    end

    def choose_faculty
      kb = ::Faculty.all.map do |faculty|
        Telegram::Bot::Types::InlineKeyboardButton.new(text: faculty.title, callback_data: { faculty: faculty.id }.to_json)
      end.each_slice(2).to_a
      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
      bot.api.send_message(chat_id: chat_id, text: 'Choose faculty', reply_markup: markup)
    end

    def choose_group
      kb = ::Group.sorted.where(department_id: user.department_id, faculty_id: user.faculty_id).map do |group|
        Telegram::Bot::Types::InlineKeyboardButton.new(text: group.title, callback_data: { group: group.id }.to_json)
      end.each_slice(2).to_a
      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
        bot.api.send_message(chat_id: chat_id, text: 'Choose group', reply_markup: markup)
    end

    def send_welcome_message
      bot.api.send_message(chat_id: chat_id, text: "Welcome, wanderer!\nBot settings -> /settings")
    end

    def chat_id
      message.from.id
    end
  end
end
