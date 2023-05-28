# frozen_string_literal: true

class Responders
  class CallbackQueryResponder
    attr_reader :message, :bot, :user

    def initialize(options)
      @bot = options[:bot]
      @message = options[:message]
      @user = User.find_or_create_by(uid: message.from.id)
    end

    def respond
      response = JSON.parse(message.attributes[:data]).symbolize_keys

      response.each do |attribute, value|
        case attribute
        when :department
          update_users_department_id(value)
          bot.api.answer_callback_query(callback_query_id: message.id, text: 'Department chosen successfully!')
        when :faculty
          update_users_faculty_id(value)
          bot.api.answer_callback_query(callback_query_id: message.id, text: 'Faculty chosen successfully!')
        when :group
          update_users_group_id(value)
          bot.api.answer_callback_query(callback_query_id: message.id, text: 'Group chosen successfully!')
        end
      end
    end

    def update_users_department_id(department_id)
      user.department_id = department_id
      user.save!
    end

    def update_users_faculty_id(faculty_id)
      user.faculty_id = faculty_id
      user.save!
    end

    def update_users_department_id(group_id)
      user.group_id = group_id
      user.save!
    end
  end
end
