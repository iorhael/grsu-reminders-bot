# frozen_string_literal: true

class Data
  class Updater
    class Base
      attr_reader :json_record

      def initialize(json_record)
        @json_record = json_record
      end

      def call
        raise NotImplementedError
      end
    end
  end
end
