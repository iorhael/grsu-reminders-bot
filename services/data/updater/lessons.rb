# frozen_string_literal: true

class Data
  class Updater
    class Lessons < Data::Updater::Base
      attr_reader :date, :group_id, :bot, :groups_lessons_with_exams

      def initialize(json_record, group_id, bot:)
        @json_record = json_record

        @group_id = group_id
        @date = Date.parse(json_record[:date])
        @bot = bot

        @groups_lessons_with_exams = []
      end

      def call
        json_record[:lessons].each do |lesson_json|
          lesson_start = at_lesson_date(Time.parse(lesson_json[:timeStart]))
          lesson_end = at_lesson_date(Time.parse(lesson_json[:timeEnd]))
          teacher_id = lesson_json[:teacher][:id].to_i

          lesson = ::Lesson.find_or_initialize_by(start: lesson_start, end: lesson_end, teacher_id:)

          attributes_to_update = lesson_json.without(:teacher, :timeStart, :timeEnd, :label)
                                            .delete_if { |_, value| value.empty? || value.is_a?(Hash) }

          lesson.assign_attributes(attributes_to_update)
          lesson.teacher_id = teacher_id

          groups_lessons_with_exams << lesson_json if lesson[:type].match?(/защита|в устной форме|в письменной форме/)

          lesson.save
        end

        notify_group_about_exams
      end

      private

      def at_lesson_date(time)
        DateTime.new(date.year, date.month, date.day, time.hour, time.min, time.sec, time.zone)
      end

      def notify_group_about_exams
        notification_texts = groups_lessons_with_exams.map { |lesson| generate_lesson_notification_text(lesson) }
        notification_text = notification_texts.join("\n\n")

        notify_group_with(group_id, notification_text)
      end

      def generate_lesson_notification_text(lesson)
        [
          "(#{lesson[:timeStart]}-#{lesson[:timeEnd]}) - *#{lesson[:title]}*",
          "_#{lesson[:teacher][:fullname]} - #{lesson[:type]}, #{lesson[:address]}, #{lesson[:room]}_"
        ].join("\n")
      end

      def notify_group_with(group_id, notification_text)
        ::Group.find(group_id).students.where(notificate: true).each do |student|
          notify(student, notification_text)
        end
      end

      def notify(user, text)
        bot.api.send_message(chat_id: user.uid, text:, parse_mode: :Markdown)
      end
    end
  end
end
