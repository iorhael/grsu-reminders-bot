# frozen_string_literal: true

class Data
  class Updater
    class Group < Data::Updater::Base
      attr_reader :faculty_id, :department_id

      def initialize(json_record, faculty_id, department_id)
        super(json_record)
        @faculty_id = faculty_id
        @department_id = department_id
      end

      def call
        return if json_record[:id].to_i.negative?

        group = ::Group.find_or_initialize_by(id: json_record[:id].to_i)
        attributes_to_update = json_record.without(:id).delete_if { |_, value| value.empty? }

        group.assign_attributes(attributes_to_update)
        group.assign_attributes(faculty_id:, department_id:)
        group.save
      end
    end
  end
end
