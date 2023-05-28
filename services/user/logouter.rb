# frozen_string_literal: true

class User
  class Logouter
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def call
      user.department = nil
      user.faculty = nil
      user.group = nil
      user.save!
    end
  end
end
