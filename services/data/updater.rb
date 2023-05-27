# frozen_string_literal: true

require 'active_support'

class Data
  class Updater
    def call
      update_departments
      update_faculties
      update_teachers
      update_groups
      update_groups_schedule
    end

    private

    def update_departments
      with_logging :department do |updated|
        fetcher.departments.each do |department_json|
          Data::Updater::Department.new(department_json).call
          updated.call
        end
      end
    end

    def update_faculties
      with_logging :faculty do |updated|
        fetcher.faculties.each do |faculty_json|
          Data::Updater::Faculty.new(faculty_json).call
          updated.call
        end
      end
    end

    def update_teachers
      with_logging :teacher do |updated|
        fetcher.teachers.each do |teacher_json|
          Data::Updater::Teacher.new(teacher_json).call
          updated.call
        end
      end
    end

    def update_groups
      departments_ids = ::Department.all.pluck(:id)
      faculties_ids = ::Faculty.all.pluck(:id)
      courses = (1..6).to_a
      possible_combinations = departments_ids.product(faculties_ids).product(courses).map(&:flatten)

      with_logging :group do |updated|
        possible_combinations.each do |department_id, faculty_id, course|
          fetcher.groups(department_id, faculty_id, course).each do |group_json|
            Data::Updater::Group.new(group_json, faculty_id, department_id).call
            updated.call
          end
        end.flatten
      end
    end

    def update_groups_schedule
      group_ids = ::Group.all.pluck(:id)
      date_frame = (Date.today..1.month.from_now.to_date)
      date_from_formatted = format_date(date_frame.first)
      date_to_formatted = format_date(date_frame.last)

      with_logging :groups do |updated|
        group_ids.each do |group_id|
          fetcher.group_schedule(group_id, date_from_formatted, date_to_formatted)&.each do |lessons_at_date_json|
            Data::Updater::Lessons.new(lessons_at_date_json, group_id).call
            updated.call
          end
        end
      end
    end

    def with_logging(object_name)
      plural_object_name = object_name.to_s.pluralize
      updated_count = 0

      updated = lambda do
        updated_count += 1
        print "Updated #{updated_count} #{plural_object_name}\r"
      end

      yield(updated)

      puts "Updated #{updated_count} #{plural_object_name}"
    end

    def format_date(date)
      date.to_s.split('-').reverse.join('.')
    end

    def fetcher
      @fetcher ||= Data::Fetcher.new
    end
  end
end
