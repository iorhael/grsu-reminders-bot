# frozen_string_literal: true

class Data
  class Updater
    class Faculty < Data::Updater::Base
      def call
        return if json_record[:id].to_i.negative?

        faculty = ::Faculty.find_or_initialize_by(id: json_record[:id].to_i)
        attributes_to_update = json_record.without(:id).delete_if { |_, value| value.empty? }

        faculty.assign_attributes(attributes_to_update)
        faculty.save
      end
    end
  end
end
