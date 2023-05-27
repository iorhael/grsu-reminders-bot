# frozen_string_literal: true

class Data::Updater

  def call
    update_departments
    update_faculties
    update_teachers
    update_groups
    update_groups_schedule
  end

  private

  def update_departments
    fetcher.departments.each do |department|
      Depar
      binding.pry
    end
  end

  def fetcher
    @fetcher = Data::Fetcher.new
  end
end
