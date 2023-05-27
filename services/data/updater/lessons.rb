# frozen_string_literal: true

class Data
  class Updater
    class Lessons < Data::Updater::Base
      attr_reader :date, :group_id

      def initialize(json_record, group_id)
        @json_record = json_record

        @group_id = group_id
        @date = Date.parse(json_record[:date])
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
          lesson.save
        end
      end

      private

      def at_lesson_date(time)
        DateTime.new(date.year, date.month, date.day, time.hour, time.min, time.sec, time.zone)
      end
    end
  end
end
