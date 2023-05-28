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
          update_users_department_id(value)
          answer_callback_query(message, 'Department chosen successfully!') do
            authenticate(user)
          end
        when :faculty
          update_users_faculty_id(value)
          answer_callback_query(message, 'Faculty chosen successfully!') do
            authenticate(user)
          end
        when :group
          update_users_group_id(value)
          answer_callback_query(message, 'Group chosen successfully!') do
            authenticate(user)
          end
        end
      end
    end

    private

    def answer_callback_query(message, respond_with_text)
      bot.api.answer_callback_query(callback_query_id: message.id, text: respond_with_text)
      yield
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
  end
end
