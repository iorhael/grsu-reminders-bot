# frozen_string_literal: true

class Data
  class Updater
    class Department < Data::Updater::Base
      def call
        return if json_record[:id].to_i.negative?

        department = ::Department.find_or_initialize_by(id: json_record[:id].to_i)
        attributes_to_update = json_record.without(:id)
        department.assign_attributes(attributes_to_update)
        department.save
      end
    end
  end
end
